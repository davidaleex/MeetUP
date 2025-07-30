//
//  ContentView.swift
//  MeetMe
//
//  Created by David Weil on 30.07.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appData: AppData
    @State private var selectedTab: TabSelection = .home
    
    enum TabSelection: String, CaseIterable {
        case home = "Home"
        case chill = "Chill"
        case friends = "Freunde"
        case leaderboard = "Ranking"
        case profile = "Profil"
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == .home ? "house.fill" : "house")
                        .font(.system(size: DesignSystem.Spacing.tabIconSize))
                    Text("Home")
                        .font(DesignSystem.Typography.caption)
                }
                .tag(TabSelection.home)
            
            // Chill Tab
            ChillView()
                .tabItem {
                    Image(systemName: selectedTab == .chill ? "timer.circle.fill" : "timer.circle")
                        .font(.system(size: DesignSystem.Spacing.tabIconSize))
                    Text("Chill")
                        .font(DesignSystem.Typography.caption)
                }
                .tag(TabSelection.chill)
            
            // Friends Tab
            FriendsView()
                .tabItem {
                    Image(systemName: selectedTab == .friends ? "person.2.fill" : "person.2")
                        .font(.system(size: DesignSystem.Spacing.tabIconSize))
                    Text("Freunde")
                        .font(DesignSystem.Typography.caption)
                }
                .tag(TabSelection.friends)
            
            // Leaderboard Tab - Neue integrierte LeaderboardView
            LeaderboardView()
                .tabItem {
                    Image(systemName: selectedTab == .leaderboard ? "trophy.fill" : "trophy")
                        .font(.system(size: DesignSystem.Spacing.tabIconSize))
                    Text("Ranking")
                        .font(DesignSystem.Typography.caption)
                }
                .tag(TabSelection.leaderboard)
            
            // Profile Tab - Erweiterte Ansicht mit Mehr-Funktionen
            ModernProfileView()
                .tabItem {
                    Image(systemName: selectedTab == .profile ? "person.circle.fill" : "person.circle")
                        .font(.system(size: DesignSystem.Spacing.tabIconSize))
                    Text("Profil")
                        .font(DesignSystem.Typography.caption)
                }
                .tag(TabSelection.profile)
        }
        .tint(DesignSystem.Colors.primary)
        .accentColor(DesignSystem.Colors.primary)
        .onAppear {
            // Customize Tab Bar Appearance
            setupTabBarAppearance()
        }
    }
    
    /// Konfiguriert das Aussehen der Tab Bar
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.shadowColor = UIColor.separator.withAlphaComponent(0.3)
        
        // Normal state
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(DesignSystem.Colors.textSecondary)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(DesignSystem.Colors.textSecondary),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        // Selected state
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(DesignSystem.Colors.primary)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(DesignSystem.Colors.primary),
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MARK: - Modern Profile View mit Mehr-Funktionen
struct ModernProfileView: View {
    @EnvironmentObject var appData: AppData
    @AppStorage("userFirstName") private var userFirstName: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: DesignSystem.Spacing.sectionSpacing) {
                    profileHeaderCard
                    quickActionsGrid
                    Spacer(minLength: DesignSystem.Spacing.xl)
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
            }
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.large)
            .background(DesignSystem.Colors.background)
        }
    }
    
    // MARK: - Profile Header Card
    private var profileHeaderCard: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            // Avatar und Name
            VStack(spacing: DesignSystem.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(DesignSystem.Colors.primaryGradient)
                        .frame(width: 80, height: 80)
                    
                    Text(displayName.prefix(2).uppercased())
                        .font(DesignSystem.Typography.title1)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                
                VStack(spacing: 4) {
                    Text(displayName)
                        .font(DesignSystem.Typography.title2)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                    
                    Text("@\(displayName.lowercased())")
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                    
                    Text(appData.userProfile.levelTitle)
                        .font(DesignSystem.Typography.caption)
                        .foregroundColor(DesignSystem.Colors.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(DesignSystem.Colors.primary.opacity(0.1))
                        .cornerRadius(DesignSystem.Radius.md)
                }
            }
            
            // Stats Row
            HStack(spacing: DesignSystem.Spacing.lg) {ProfileStatItem(
                    title: "Level",
                    value: "\(appData.userProfile.level)",
                    icon: "star.fill",
                    color: DesignSystem.Colors.warning
                )
                
                Divider()
                    .frame(height: 40)
                
                ProfileStatItem(
                    title: "Punkte",
                    value: "\(appData.totalPoints)",
                    icon: "flame.fill",
                    color: DesignSystem.Colors.secondary
                )
                
                Divider()
                    .frame(height: 40)
                
                ProfileStatItem(
                    title: "Sessions",
                    value: "\(appData.totalSessions)",
                    icon: "timer.circle.fill",
                    color: DesignSystem.Colors.info
                )
            }
        }
        .padding(DesignSystem.Spacing.cardPadding)
        .cardStyle()
    }
    
    // MARK: - Quick Actions Grid
    private var quickActionsGrid: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            HStack {
                Text("Schnellzugriff")
                    .font(DesignSystem.Typography.title2)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: DesignSystem.Spacing.md) {
                
                QuickActionCard(
                    title: "Challenges",
                    icon: "target",
                    color: DesignSystem.Colors.secondary,
                    destination: AnyView(ChallengesView())
                )
                
                QuickActionCard(
                    title: "Ranking",
                    icon: "trophy.fill",
                    color: DesignSystem.Colors.warning,
                    destination: AnyView(RankingView())
                )
                
                QuickActionCard(
                    title: "Einstellungen",
                    icon: "gearshape.fill",
                    color: DesignSystem.Colors.textSecondary,
                    destination: AnyView(SettingsView())
                )
                
                QuickActionCard(
                    title: "Statistiken",
                    icon: "chart.bar.fill",
                    color: DesignSystem.Colors.info,
                    destination: AnyView(Text("Statistiken - Coming Soon"))
                )
            }
        }
    }
    
    /// Zeigt den richtigen Namen an
    private var displayName: String {
        return !userFirstName.isEmpty ? userFirstName : appData.userProfile.username
    }
}

// MARK: - Profile Stat Item Component
struct ProfileStatItem: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xs) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(DesignSystem.Typography.headline)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            Text(title)
                .font(DesignSystem.Typography.caption)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Quick Action Card Component
struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: DesignSystem.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(DesignSystem.Typography.callout)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ContentView()
        .environmentObject(AppData())
}
