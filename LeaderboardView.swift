import SwiftUI

// MARK: - Leaderboard View mit Top-3 Podium und Rangliste
struct LeaderboardView: View {
    @EnvironmentObject var appData: AppData
    @AppStorage("userFirstName") private var userFirstName: String = ""
    
    // Animation States
    @State private var showPodium = false
    @State private var showList = false
    @State private var animateTrophies = false
    @State private var selectedTimeframe: TimeFrame = .weekly
    
    enum TimeFrame: String, CaseIterable {
        case weekly = "Diese Woche"
        case monthly = "Diesen Monat"
        case allTime = "Alle Zeit"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: DesignSystem.Spacing.sectionSpacing) {
                    headerSection
                    timeframeSelector
                    podiumSection
                    leaderboardList
                    personalStats
                    Spacer(minLength: DesignSystem.Spacing.xl)
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
            }
            .navigationTitle("Rangliste")
            .navigationBarTitleDisplayMode(.large)
            .background(DesignSystem.Colors.background)
            .refreshable {
                await refreshLeaderboard()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            HStack {
                Text("Hi \(displayName)! 🏆")
                    .font(DesignSystem.Typography.title1)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
            }
            
            HStack {
                Text("Sieh dir die Top-Chiller deiner Freunde an!")
                    .font(DesignSystem.Typography.callout)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
                Spacer()
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.xs)
    }
    
    // MARK: - Timeframe Selector
    private var timeframeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignSystem.Spacing.sm) {
                ForEach(TimeFrame.allCases, id: \.self) { timeframe in
                    Button(action: {
                        withAnimation(DesignSystem.Animation.smooth) {
                            selectedTimeframe = timeframe
                        }
                    }) {
                        Text(timeframe.rawValue)
                            .font(DesignSystem.Typography.callout)
                            .foregroundColor(selectedTimeframe == timeframe ? .white : DesignSystem.Colors.primary)
                            .padding(.horizontal, DesignSystem.Spacing.md)
                            .padding(.vertical, DesignSystem.Spacing.sm)
                            .background(
                                selectedTimeframe == timeframe ?
                                AnyShapeStyle(DesignSystem.Colors.primaryGradient) :
                                AnyShapeStyle(DesignSystem.Colors.primary.opacity(0.1))
                            )
                            .cornerRadius(DesignSystem.Radius.md)
                    }
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
        }
    }
    
    // MARK: - Podium Section (Top 3)
    private var podiumSection: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            Text("Top 3 Chill-Champions")
                .font(DesignSystem.Typography.title2)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            HStack(alignment: .bottom, spacing: DesignSystem.Spacing.sm) {
                // 2nd Place - Links
                if topFriends.indices.contains(1) {
                    PodiumPosition(
                        friend: topFriends[1],
                        position: 2,
                        height: 100,
                        color: DesignSystem.Colors.separator,
                        showAnimation: $showPodium
                    )
                } else {
                    EmptyPodiumPosition(position: 2, height: 100)
                }
                
                // 1st Place - Mitte (höchstes Podium)
                if topFriends.indices.contains(0) {
                    PodiumPosition(
                        friend: topFriends[0],
                        position: 1,
                        height: 130,
                        color: DesignSystem.Colors.warning,
                        showAnimation: $showPodium
                    )
                } else {
                    EmptyPodiumPosition(position: 1, height: 130)
                }
                
                // 3rd Place - Rechts
                if topFriends.indices.contains(2) {
                    PodiumPosition(
                        friend: topFriends[2],
                        position: 3,
                        height: 80,
                        color: DesignSystem.Colors.secondary,
                        showAnimation: $showPodium
                    )
                } else {
                    EmptyPodiumPosition(position: 3, height: 80)
                }
            }
            .opacity(showPodium ? 1.0 : 0.0)
            .animation(DesignSystem.Animation.smooth.delay(0.3), value: showPodium)
        }
        .padding(DesignSystem.Spacing.cardPadding)
        .cardStyle()
    }
    
    // MARK: - Leaderboard List
    private var leaderboardList: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            HStack {
                Text("Komplette Rangliste")
                    .font(DesignSystem.Typography.title2)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
                
                Text("\(appData.friendsRanking.count) Freunde")
                    .font(DesignSystem.Typography.footnote)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            
            LazyVStack(spacing: DesignSystem.Spacing.sm) {
                ForEach(Array(appData.friendsRanking.enumerated()), id: \.element.id) { index, friend in
                    LeaderboardRow(
                        friend: friend,
                        position: index + 1,
                        isCurrentUser: false
                    )
                    .opacity(showList ? 1.0 : 0.0)
                    .animation(
                        DesignSystem.Animation.smooth.delay(Double(index) * 0.1),
                        value: showList
                    )
                }
            }
        }
        .padding(DesignSystem.Spacing.cardPadding)
        .cardStyle()
    }
    
    // MARK: - Personal Stats
    private var personalStats: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            HStack {
                Text("Deine Position")
                    .font(DesignSystem.Typography.title2)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
            }
            
            HStack(spacing: DesignSystem.Spacing.md) {
                VStack(spacing: DesignSystem.Spacing.sm) {
                    Text("Rang")
                        .font(DesignSystem.Typography.caption)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                    
                    Text("#\(userRank)")
                        .font(DesignSystem.Typography.statNumber)
                        .foregroundColor(DesignSystem.Colors.primary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignSystem.Spacing.lg)
                .cardStyle()
                
                VStack(spacing: DesignSystem.Spacing.sm) {
                    Text("Deine Punkte")
                        .font(DesignSystem.Typography.caption)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                    
                    Text("\(appData.totalPoints)")
                        .font(DesignSystem.Typography.statNumber)
                        .foregroundColor(DesignSystem.Colors.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignSystem.Spacing.lg)
                .cardStyle()
            }
            
            // Motivationstext basierend auf Rang
            Text(motivationalText)
                .font(DesignSystem.Typography.callout)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignSystem.Spacing.md)
        }
        .padding(DesignSystem.Spacing.cardPadding)
        .cardStyle()
    }
    
    // MARK: - Computed Properties
    
    /// Zeigt den richtigen Namen an
    private var displayName: String {
        return !userFirstName.isEmpty ? userFirstName : appData.userProfile.username
    }
    
    /// Top 3 Freunde sortiert nach Chill-Minuten
    private var topFriends: [Friend] {
        return Array(appData.friendsRanking.prefix(3))
    }
    
    /// Rang des aktuellen Benutzers (simuliert)
    private var userRank: Int {
        // Da der User nicht in der Freundesliste steht, simulieren wir einen Rang
        let userPoints = appData.totalPoints
        let betterFriends = appData.friends.filter { friend in
            // Punkte basierend auf Chill-Minuten schätzen (ca. 10 Punkte pro Minute)
            friend.totalChillMinutes * 10 > userPoints
        }
        return betterFriends.count + 1
    }
    
    /// Motivationstext basierend auf dem Rang
    private var motivationalText: String {
        switch userRank {
        case 1:
            return "🎉 Du bist die #1! Unfassbar! Du dominierst das Chill-Game!"
        case 2...3:
            return "🔥 Fast an der Spitze! Nur noch ein kleiner Push zur #1!"
        case 4...5:
            return "💪 Top 5! Du bist auf einem super Weg nach oben!"
        case 6...10:
            return "📈 Top 10! Weiter so, du steigst immer weiter!"
        default:
            return "🚀 Zeit zum Aufholen! Chille mehr mit Freunden und klettere nach oben!"
        }
    }
    
    // MARK: - Functions
    
    /// Startet alle Animationen
    private func startAnimations() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showPodium = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showList = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            animateTrophies = true
        }
    }
    
    /// Refresh-Funktion
    private func refreshLeaderboard() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Re-trigger animations
        showPodium = false
        showList = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            startAnimations()
        }
    }
}

// MARK: - Podium Position Component
struct PodiumPosition: View {
    let friend: Friend
    let position: Int
    let height: CGFloat
    let color: Color
    @Binding var showAnimation: Bool
    
    @State private var bounce = false
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            // Trophäe/Medal
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: trophyIcon)
                    .font(.title)
                    .foregroundColor(color)
                    .scaleEffect(bounce ? 1.2 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                        value: bounce
                    )
            }
            
            // Name
            Text(friend.name.components(separatedBy: " ").first ?? friend.name)
                .font(DesignSystem.Typography.callout)
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .lineLimit(1)
            
            // Stats
            VStack(spacing: 2) {
                Text("\(friend.totalChillMinutes)")
                    .font(DesignSystem.Typography.bodyBold)
                    .foregroundColor(color)
                
                Text("Minuten")
                    .font(DesignSystem.Typography.caption2)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            
            // Podium
            Rectangle()
                .fill(LinearGradient(
                    colors: [color.opacity(0.8), color.opacity(0.4)],
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .frame(width: 70, height: height)
                .customCornerRadius(DesignSystem.Radius.sm, corners: [.topLeft, .topRight])
                .overlay(
                    Text("\(position)")
                        .font(DesignSystem.Typography.title1)
                        .foregroundColor(.white)
                        .fontWeight(.black)
                )
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(position) * 0.2) {
                bounce = true
            }
        }
    }
    
    private var trophyIcon: String {
        switch position {
        case 1: return "crown.fill"
        case 2: return "medal.fill"
        case 3: return "award.fill"
        default: return "star.fill"
        }
    }
}

// MARK: - Empty Podium Component
struct EmptyPodiumPosition: View {
    let position: Int
    let height: CGFloat
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            ZStack {
                Circle()
                    .fill(DesignSystem.Colors.separator.opacity(0.3))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "questionmark")
                    .font(.title2)
                    .foregroundColor(DesignSystem.Colors.textTertiary)
            }
            
            Text("?")
                .font(DesignSystem.Typography.callout)
                .foregroundColor(DesignSystem.Colors.textTertiary)
            
            VStack(spacing: 2) {
                Text("--")
                    .font(DesignSystem.Typography.bodyBold)
                    .foregroundColor(DesignSystem.Colors.textTertiary)
                
                Text("Minuten")
                    .font(DesignSystem.Typography.caption2)
                    .foregroundColor(DesignSystem.Colors.textTertiary)
            }
            
            Rectangle()
                .fill(DesignSystem.Colors.separator.opacity(0.3))
                .frame(width: 70, height: height)
                .customCornerRadius(DesignSystem.Radius.sm, corners: [.topLeft, .topRight])
                .overlay(
                    Text("\(position)")
                        .font(DesignSystem.Typography.title1)
                        .foregroundColor(DesignSystem.Colors.textTertiary)
                        .fontWeight(.black)
                )
        }
    }
}

// MARK: - Leaderboard Row Component
struct LeaderboardRow: View {
    let friend: Friend
    let position: Int
    let isCurrentUser: Bool
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            // Position
            Text("#\(position)")
                .font(DesignSystem.Typography.bodyBold)
                .foregroundColor(positionColor)
                .frame(width: 30, alignment: .leading)
            
            // Avatar
            ZStack {
                Circle()
                    .fill(DesignSystem.Colors.primaryGradient)
                    .frame(width: 40, height: 40)
                
                Text(friend.initials)
                    .font(DesignSystem.Typography.callout)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
            }
            
            // Name und Stats
            VStack(alignment: .leading, spacing: 2) {
                Text(friend.name)
                    .font(DesignSystem.Typography.bodyBold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text("Level \(friend.bondLevel) • \(friend.bondTitle)")
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            
            Spacer()
            
            // Chill-Minuten
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(friend.totalChillMinutes)")
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Colors.primary)
                
                Text("Minuten")
                    .font(DesignSystem.Typography.caption2)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
        }
        .padding(DesignSystem.Spacing.md)
        .background(
            isCurrentUser ? 
            DesignSystem.Colors.primary.opacity(0.1) : 
            DesignSystem.Colors.cardBackground
        )
        .cornerRadius(DesignSystem.Radius.md)
        .softShadow()
    }
    
    private var positionColor: Color {
        switch position {
        case 1: return DesignSystem.Colors.warning
        case 2: return DesignSystem.Colors.separator
        case 3: return DesignSystem.Colors.secondary
        default: return DesignSystem.Colors.textSecondary
        }
    }
}

// MARK: - Corner Radius Extension
extension View {
    func customCornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    LeaderboardView()
        .environmentObject(AppData())
}