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
                VStack(spacing: Spacing.sectionSpacing) {
                    headerSection
                    timeframeSelector
                    podiumSection
                    leaderboardList
                    personalStats
                    Spacer(minLength: Spacing.xl)
                }
                .padding(.horizontal, Spacing.md)
            }
            .navigationTitle("Rangliste")
            .navigationBarTitleDisplayMode(.large)
            .background(Colors.background)
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
        VStack(spacing: Spacing.sm) {
            HStack {
                Text("Hi \(displayName)! 🏆")
                    .font(Typography.title1)
                    .foregroundColor(Colors.textPrimary)
                
                Spacer()
            }
            
            HStack {
                Text("Sieh dir die Top-Chiller deiner Freunde an!")
                    .font(Typography.callout)
                    .foregroundColor(Colors.textSecondary)
                
                Spacer()
            }
        }
        .padding(.horizontal, Spacing.xs)
    }
    
    // MARK: - Timeframe Selector
    private var timeframeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.sm) {
                ForEach(TimeFrame.allCases, id: \.self) { timeframe in
                    Button(action: {
                        withAnimation(Animation.smooth) {
                            selectedTimeframe = timeframe
                        }
                    }) {
                        Text(timeframe.rawValue)
                            .font(Typography.callout)
                            .foregroundColor(selectedTimeframe == timeframe ? .white : Colors.primary)
                            .padding(.horizontal, Spacing.md)
                            .padding(.vertical, Spacing.sm)
                            .background(
                                selectedTimeframe == timeframe ?
                                AnyShapeStyle(Colors.primaryGradient) :
                                AnyShapeStyle(Colors.primary.opacity(0.1))
                            )
                            .cornerRadius(Radius.md)
                    }
                }
            }
            .padding(.horizontal, Spacing.md)
        }
    }
    
    // MARK: - Podium Section (Top 3)
    private var podiumSection: some View {
        VStack(spacing: Spacing.lg) {
            Text("Top 3 Chill-Champions")
                .font(Typography.title2)
                .foregroundColor(Colors.textPrimary)
            
            HStack(alignment: .bottom, spacing: Spacing.sm) {
                // 2nd Place - Links
                if topFriends.indices.contains(1) {
                    PodiumPosition(
                        friend: topFriends[1],
                        position: 2,
                        height: 100,
                        color: Colors.separator,
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
                        color: Colors.warning,
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
                        color: Colors.secondary,
                        showAnimation: $showPodium
                    )
                } else {
                    EmptyPodiumPosition(position: 3, height: 80)
                }
            }
            .opacity(showPodium ? 1.0 : 0.0)
            .animation(Animation.smooth.delay(0.3), value: showPodium)
        }
        .padding(Spacing.cardPadding)
        .cardStyle()
    }
    
    // MARK: - Leaderboard List
    private var leaderboardList: some View {
        VStack(spacing: Spacing.md) {
            HStack {
                Text("Komplette Rangliste")
                    .font(Typography.title2)
                    .foregroundColor(Colors.textPrimary)
                
                Spacer()
                
                Text("\(appData.friendsRanking.count) Freunde")
                    .font(Typography.footnote)
                    .foregroundColor(Colors.textSecondary)
            }
            
            LazyVStack(spacing: Spacing.sm) {
                ForEach(Array(appData.friendsRanking.enumerated()), id: \.element.id) { index, friend in
                    LeaderboardRow(
                        friend: friend,
                        position: index + 1,
                        isCurrentUser: false
                    )
                    .opacity(showList ? 1.0 : 0.0)
                    .animation(
                        Animation.smooth.delay(Double(index) * 0.1),
                        value: showList
                    )
                }
            }
        }
        .padding(Spacing.cardPadding)
        .cardStyle()
    }
    
    // MARK: - Personal Stats
    private var personalStats: some View {
        VStack(spacing: Spacing.md) {
            HStack {
                Text("Deine Position")
                    .font(Typography.title2)
                    .foregroundColor(Colors.textPrimary)
                
                Spacer()
            }
            
            HStack(spacing: Spacing.md) {
                VStack(spacing: Spacing.sm) {
                    Text("Rang")
                        .font(Typography.caption)
                        .foregroundColor(Colors.textSecondary)
                    
                    Text("#\(userRank)")
                        .font(Typography.statNumber)
                        .foregroundColor(Colors.primary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.lg)
                .cardStyle()
                
                VStack(spacing: Spacing.sm) {
                    Text("Deine Punkte")
                        .font(Typography.caption)
                        .foregroundColor(Colors.textSecondary)
                    
                    Text("\(appData.totalPoints)")
                        .font(Typography.statNumber)
                        .foregroundColor(Colors.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.lg)
                .cardStyle()
            }
            
            // Motivationstext basierend auf Rang
            Text(motivationalText)
                .font(Typography.callout)
                .foregroundColor(Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.md)
        }
        .padding(Spacing.cardPadding)
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
        VStack(spacing: Spacing.sm) {
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
                .font(Typography.callout)
                .foregroundColor(Colors.textPrimary)
                .lineLimit(1)
            
            // Stats
            VStack(spacing: 2) {
                Text("\(friend.totalChillMinutes)")
                    .font(Typography.bodyBold)
                    .foregroundColor(color)
                
                Text("Minuten")
                    .font(Typography.caption2)
                    .foregroundColor(Colors.textSecondary)
            }
            
            // Podium
            Rectangle()
                .fill(LinearGradient(
                    colors: [color.opacity(0.8), color.opacity(0.4)],
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .frame(width: 70, height: height)
                .customCornerRadius(Radius.sm, corners: [.topLeft, .topRight])
                .overlay(
                    Text("\(position)")
                        .font(Typography.title1)
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
        VStack(spacing: Spacing.sm) {
            ZStack {
                Circle()
                    .fill(Colors.separator.opacity(0.3))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "questionmark")
                    .font(.title2)
                    .foregroundColor(Colors.textTertiary)
            }
            
            Text("?")
                .font(Typography.callout)
                .foregroundColor(Colors.textTertiary)
            
            VStack(spacing: 2) {
                Text("--")
                    .font(Typography.bodyBold)
                    .foregroundColor(Colors.textTertiary)
                
                Text("Minuten")
                    .font(Typography.caption2)
                    .foregroundColor(Colors.textTertiary)
            }
            
            Rectangle()
                .fill(Colors.separator.opacity(0.3))
                .frame(width: 70, height: height)
                .customCornerRadius(Radius.sm, corners: [.topLeft, .topRight])
                .overlay(
                    Text("\(position)")
                        .font(Typography.title1)
                        .foregroundColor(Colors.textTertiary)
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
        HStack(spacing: Spacing.md) {
            // Position
            Text("#\(position)")
                .font(Typography.bodyBold)
                .foregroundColor(positionColor)
                .frame(width: 30, alignment: .leading)
            
            // Avatar
            ZStack {
                Circle()
                    .fill(Colors.primaryGradient)
                    .frame(width: 40, height: 40)
                
                Text(friend.initials)
                    .font(Typography.callout)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
            }
            
            // Name und Stats
            VStack(alignment: .leading, spacing: 2) {
                Text(friend.name)
                    .font(Typography.bodyBold)
                    .foregroundColor(Colors.textPrimary)
                
                Text("Level \(friend.bondLevel) • \(friend.bondTitle)")
                    .font(Typography.caption)
                    .foregroundColor(Colors.textSecondary)
            }
            
            Spacer()
            
            // Chill-Minuten
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(friend.totalChillMinutes)")
                    .font(Typography.headline)
                    .foregroundColor(Colors.primary)
                
                Text("Minuten")
                    .font(Typography.caption2)
                    .foregroundColor(Colors.textSecondary)
            }
        }
        .padding(Spacing.md)
        .background(
            isCurrentUser ? 
            Colors.primary.opacity(0.1) : 
            Colors.cardBackground
        )
        .cornerRadius(Radius.md)
        .softShadow()
    }
    
    private var positionColor: Color {
        switch position {
        case 1: return Colors.warning
        case 2: return Colors.separator
        case 3: return Colors.secondary
        default: return Colors.textSecondary
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