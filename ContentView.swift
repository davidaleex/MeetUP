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
        case friends = "Freunde"
        case ranking = "Ranking"
        case stats = "Stats"
        case profile = "Profil"
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == .home ? "house.fill" : "house")
                        .font(.system(size: Spacing.tabIconSize))
                    Text("Home")
                        .font(Typography.caption)
                }
                .tag(TabSelection.home)
            
            // Friends Tab
            FriendsView()
                .tabItem {
                    Image(systemName: selectedTab == .friends ? "person.2.fill" : "person.2")
                        .font(.system(size: Spacing.tabIconSize))
                    Text("Freunde")
                        .font(Typography.caption)
                }
                .tag(TabSelection.friends)
            
            // Ranking Tab
            RankingView()
                .tabItem {
                    Image(systemName: selectedTab == .ranking ? "trophy.fill" : "trophy")
                        .font(.system(size: Spacing.tabIconSize))
                    Text("Ranking")
                        .font(Typography.caption)
                }
                .tag(TabSelection.ranking)
            
            // Stats Tab - Detaillierte Statistiken
            StatsTabView()
                .tabItem {
                    Image(systemName: selectedTab == .stats ? "chart.bar.fill" : "chart.bar")
                        .font(.system(size: Spacing.tabIconSize))
                    Text("Stats")
                        .font(Typography.caption)
                }
                .tag(TabSelection.stats)
            
            // Profile Tab - Erweiterte Ansicht mit Mehr-Funktionen
            ModernProfileView()
                .tabItem {
                    Image(systemName: selectedTab == .profile ? "person.circle.fill" : "person.circle")
                        .font(.system(size: Spacing.tabIconSize))
                    Text("Profil")
                        .font(Typography.caption)
                }
                .tag(TabSelection.profile)
        }
        .tint(Colors.primary)
        .accentColor(Colors.primary)
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
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Colors.textSecondary)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Colors.textSecondary),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        // Selected state
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Colors.primary)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Colors.primary),
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
                VStack(spacing: Spacing.sectionSpacing) {
                    profileHeaderCard
                    quickActionsGrid
                    Spacer(minLength: Spacing.xl)
                }
                .padding(.horizontal, Spacing.md)
            }
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.large)
            .background(Colors.background)
        }
    }
    
    // MARK: - Profile Header Card
    private var profileHeaderCard: some View {
        VStack(spacing: Spacing.lg) {
            // Avatar und Name
            VStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(Colors.primaryGradient)
                        .frame(width: 80, height: 80)
                    
                    Text(displayName.prefix(2).uppercased())
                        .font(Typography.title1)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                
                VStack(spacing: 4) {
                    Text(displayName)
                        .font(Typography.title2)
                        .foregroundColor(Colors.textPrimary)
                    
                    Text("@\(displayName.lowercased())")
                        .font(Typography.subheadline)
                        .foregroundColor(Colors.textSecondary)
                    
                    Text(appData.userProfile.levelTitle)
                        .font(Typography.caption)
                        .foregroundColor(Colors.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Colors.primary.opacity(0.1))
                        .cornerRadius(Radius.md)
                }
            }
            
            // Stats Row
            HStack(spacing: Spacing.lg) {ProfileStatItem(
                    title: "Level",
                    value: "\(appData.userProfile.level)",
                    icon: "star.fill",
                    color: Colors.warning
                )
                
                Divider()
                    .frame(height: 40)
                
                ProfileStatItem(
                    title: "Punkte",
                    value: "\(appData.totalPoints)",
                    icon: "flame.fill",
                    color: Colors.secondary
                )
                
                Divider()
                    .frame(height: 40)
                
                ProfileStatItem(
                    title: "Sessions",
                    value: "\(appData.totalSessions)",
                    icon: "timer.circle.fill",
                    color: Colors.info
                )
            }
        }
        .padding(Spacing.cardPadding)
        .cardStyle()
    }
    
    // MARK: - Quick Actions Grid
    private var quickActionsGrid: some View {
        VStack(spacing: Spacing.md) {
            HStack {
                Text("Schnellzugriff")
                    .font(Typography.title2)
                    .foregroundColor(Colors.textPrimary)
                
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.md) {
                
                QuickActionCard(
                    title: "Challenges",
                    icon: "target",
                    color: Colors.secondary,
                    destination: AnyView(ChallengesView())
                )
                
                QuickActionCard(
                    title: "Ranking",
                    icon: "trophy.fill",
                    color: Colors.warning,
                    destination: AnyView(RankingView())
                )
                
                QuickActionCard(
                    title: "Einstellungen",
                    icon: "gearshape.fill",
                    color: Colors.textSecondary,
                    destination: AnyView(SettingsView())
                )
                
                QuickActionCard(
                    title: "Statistiken",
                    icon: "chart.bar.fill",
                    color: Colors.info,
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
        VStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(Typography.headline)
                .foregroundColor(Colors.textPrimary)
            
            Text(title)
                .font(Typography.caption)
                .foregroundColor(Colors.textSecondary)
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
            VStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(Typography.callout)
                    .foregroundColor(Colors.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Stats Tab View
struct StatsTabView: View {
    @EnvironmentObject var appData: AppData
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: Spacing.sectionSpacing) {
                    // Übersicht Stats
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        Text("Übersicht")
                            .font(Typography.title2)
                            .foregroundColor(Colors.textPrimary)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: Spacing.md) {
                            StatCardView(
                                title: "Gesamt Punkte",
                                value: "\(appData.totalPoints)",
                                icon: "flame.fill",
                                color: Colors.secondary
                            )
                            
                            StatCardView(
                                title: "Level",
                                value: "\(appData.userProfile.level)",
                                icon: "star.fill",
                                color: Colors.warning
                            )
                            
                            StatCardView(
                                title: "Sessions",
                                value: "\(appData.totalSessions)",
                                icon: "play.circle.fill",
                                color: Colors.primary
                            )
                            
                            StatCardView(
                                title: "Chill Zeit",
                                value: "\(appData.totalChillMinutes)m",
                                icon: "timer.circle.fill",
                                color: Colors.info
                            )
                        }
                    }
                    .padding(Spacing.cardPadding)
                    .cardStyle()
                    
                    // Diese Woche
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        Text("Diese Woche")
                            .font(Typography.title2)
                            .foregroundColor(Colors.textPrimary)
                        
                        VStack(spacing: Spacing.md) {
                            StatRowView(
                                title: "Punkte gesammelt",
                                value: "\(appData.weeklyStats.pointsEarned)",
                                icon: "plus.circle.fill",
                                color: Colors.success
                            )
                            
                            StatRowView(
                                title: "Sessions gestartet",
                                value: "\(appData.weeklyStats.sessionsCount)",
                                icon: "play.fill",
                                color: Colors.primary
                            )
                            
                            StatRowView(
                                title: "Aktive Freunde",
                                value: "\(appData.weeklyStats.uniqueFriendsCount)",
                                icon: "person.2.fill",
                                color: Colors.info
                            )
                        }
                    }
                    .padding(Spacing.cardPadding)
                    .cardStyle()
                    
                    Spacer(minLength: Spacing.xl)
                }
                .padding(.horizontal, Spacing.md)
            }
            .navigationTitle("Statistiken")
            .navigationBarTitleDisplayMode(.large)
            .background(Colors.background)
        }
    }
}

// MARK: - Stat Card View Component
struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(Typography.statNumber)
                .foregroundColor(Colors.textPrimary)
            
            Text(title)
                .font(Typography.caption)
                .foregroundColor(Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.md)
        .background(Colors.cardBackground)
        .cornerRadius(Radius.md)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.md)
                .stroke(Colors.separator, lineWidth: 0.5)
        )
    }
}

// MARK: - Stat Row View Component
struct StatRowView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Typography.callout)
                    .foregroundColor(Colors.textPrimary)
                
                Text(value)
                    .font(Typography.caption)
                    .foregroundColor(Colors.textSecondary)
            }
            
            Spacer()
        }
    }
}
