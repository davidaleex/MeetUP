import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appData: AppData
    @AppStorage("userFirstName") private var userFirstName: String = ""
    
    // States
    @State private var showSessionDetails = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: Spacing.sectionSpacing) {
                    // Active Session Banner (wenn aktiv)
                    if appData.isChilling {
                        activeSessionBanner
                    }
                    
                    // Welcome & Quick Stats
                    welcomeHeader
                    
                    // Online Friends - Direct Chill Actions
                    onlineFriendsSection
                    
                    // Solo Chill Option
                    soloChillCard
                    
                    // Today's Challenges (Mini Version)
                    todayChallengesCard
                    
                    // Quick Stats Overview
                    quickStatsGrid
                    
                    Spacer(minLength: Spacing.xl)
                }
                .padding(.horizontal, Spacing.md)
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .background(Colors.background)
            .refreshable {
                await refreshData()
            }
        }
    }
    
    // MARK: - Active Session Banner
    private var activeSessionBanner: some View {
        HStack(spacing: Spacing.md) {
            // Animated Pulse Dot
            Circle()
                .fill(Colors.success)
                .frame(width: 12, height: 12)
                .scaleEffect(1.2)
                .animation(
                    Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                    value: appData.isChilling
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Session läuft")
                    .font(Typography.callout)
                    .foregroundColor(Colors.success)
                    .fontWeight(.semibold)
                
                if let session = appData.currentSession {
                    Text("Mit \(session.friendNames.joined(separator: ", "))")
                        .font(Typography.caption)
                        .foregroundColor(Colors.textSecondary)
                }
            }
            
            Spacer()
            
            Button("Beenden") {
                endCurrentSession()
            }
            .font(Typography.caption)
            .foregroundColor(.white)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .background(Colors.error)
            .cornerRadius(Radius.md)
        }
        .padding(Spacing.md)
        .background(Colors.success.opacity(0.1))
        .cornerRadius(Radius.lg)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.lg)
                .stroke(Colors.success.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Welcome Header
    private var welcomeHeader: some View {
        VStack(spacing: Spacing.md) {
            // Greeting
            HStack {
                Text(Strings.Personalized.timeBasedGreeting(name: displayName))
                    .font(Typography.title2)
                    .foregroundColor(Colors.textPrimary)
                
                Spacer()
            }
            
            // Quick Stats Row
            HStack(spacing: Spacing.lg) {
                QuickStatItem(
                    title: "Punkte",
                    value: "\(appData.totalPoints)",
                    icon: "flame.fill",
                    color: Colors.secondary
                )
                
                QuickStatItem(
                    title: "Level",
                    value: "\(appData.userProfile.level)",
                    icon: "star.fill",
                    color: Colors.warning
                )
                
                QuickStatItem(
                    title: "Diese Woche",
                    value: "+\(appData.weeklyStats.pointsEarned)",
                    icon: "arrow.up.circle.fill",
                    color: Colors.success
                )
                
                Spacer()
            }
        }
        .padding(Spacing.cardPadding)
        .cardStyle()
    }
    
    // MARK: - Online Friends Section
    private var onlineFriendsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Text("Wer ist online?")
                    .font(Typography.title2)
                    .foregroundColor(Colors.textPrimary)
                
                Spacer()
                
                if onlineFriends.isEmpty {
                    Text("Niemand online")
                        .font(Typography.caption)
                        .foregroundColor(Colors.textSecondary)
                }
            }
            
            if onlineFriends.isEmpty {
                // Empty State
                VStack(spacing: Spacing.md) {
                    Image(systemName: "person.2.slash")
                        .font(.system(size: 40))
                        .foregroundColor(Colors.textSecondary.opacity(0.5))
                    
                    Text("Keine Freunde online")
                        .font(Typography.callout)
                        .foregroundColor(Colors.textSecondary)
                    
                    Text("Lade Freunde ein oder starte eine Solo-Session!")
                        .font(Typography.caption)
                        .foregroundColor(Colors.textSecondary.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(Spacing.xl)
                .background(Colors.cardBackground.opacity(0.5))
                .cornerRadius(Radius.lg)
            } else {
                // Online Friends Cards
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: Spacing.md) {
                    ForEach(onlineFriends) { friend in
                        OnlineFriendCard(friend: friend) {
                            startChillWithFriend(friend)
                        }
                    }
                }
            }
        }
        .padding(Spacing.cardPadding)
        .cardStyle()
    }
    
    // MARK: - Solo Chill Card
    private var soloChillCard: some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(Colors.info.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "person.fill")
                    .font(.title2)
                    .foregroundColor(Colors.info)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Solo entspannen")
                    .font(Typography.headline)
                    .foregroundColor(Colors.textPrimary)
                
                Text("5-15 Min für dich alleine")
                    .font(Typography.caption)
                    .foregroundColor(Colors.textSecondary)
            }
            
            Spacer()
            
            Button("Start") {
                startSoloSession()
            }
            .font(Typography.callout)
            .foregroundColor(.white)
            .padding(.horizontal, Spacing.lg)
            .padding(.vertical, Spacing.sm)
            .background(Colors.info)
            .cornerRadius(Radius.md)
        }
        .padding(Spacing.cardPadding)
        .cardStyle()
    }
    
    // MARK: - Today's Challenges
    private var todayChallengesCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Text("Heute's Challenges")
                    .font(Typography.title2)
                    .foregroundColor(Colors.textPrimary)
                
                Spacer()
                
                NavigationLink(destination: ChallengesView()) {
                    Text("Alle")
                        .font(Typography.caption)
                        .foregroundColor(Colors.primary)
                }
            }
            
            VStack(spacing: Spacing.sm) {
                ForEach(appData.challenges.prefix(2)) { challenge in
                    TodayChallengeRow(challenge: challenge)
                }
            }
        }
        .padding(Spacing.cardPadding)
        .cardStyle()
    }
    
    // MARK: - Quick Stats Grid
    private var quickStatsGrid: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Quick Stats")
                .font(Typography.title2)
                .foregroundColor(Colors.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.md) {
                MiniStatCard(
                    title: "Sessions",
                    value: "\(appData.totalSessions)",
                    icon: "play.circle.fill",
                    color: Colors.primary
                )
                
                MiniStatCard(
                    title: "Chill Zeit",
                    value: "\(appData.totalChillMinutes)m",
                    icon: "timer.circle.fill",
                    color: Colors.info
                )
                
                MiniStatCard(
                    title: "Top Friend",
                    value: appData.topFriend?.name.components(separatedBy: " ").first ?? "Keine",
                    icon: "person.crop.circle.fill",
                    color: Colors.secondary
                )
                
                MiniStatCard(
                    title: "Achievements",
                    value: "5", // Placeholder
                    icon: "trophy.fill",
                    color: Colors.warning
                )
            }
        }
        .padding(Spacing.cardPadding)
        .cardStyle()
    }
    
    // MARK: - Helper Properties
    private var displayName: String {
        return !userFirstName.isEmpty ? userFirstName : appData.userProfile.username
    }
    
    private var onlineFriends: [Friend] {
        return appData.friends.filter { $0.isOnline }
    }
    
    // MARK: - Actions
    private func startChillWithFriend(_ friend: Friend) {
        // Clear previous selections
        appData.clearSelectedFriends()
        // Add selected friend
        appData.addFriend(friend)
        // Start session
        appData.startChillSession()
        
        // Show feedback
        print("🎯 Started chill session with \(friend.name)")
    }
    
    private func startSoloSession() {
        // Clear friends for solo session
        appData.clearSelectedFriends()
        
        // Create a solo "session" (simplified)
        let soloDuration = Int.random(in: 5...15)
        let soloPoints = soloDuration * 2
        
        // Simulate quick solo session
        appData.addPoints(soloPoints, showAnimation: true)
        appData.totalChillMinutes += soloDuration
        appData.totalSessions += 1
        
        print("🧘‍♀️ Solo session completed: \(soloDuration)min, +\(soloPoints) points")
    }
    
    private func endCurrentSession() {
        // End current session with some random values
        let duration = Int.random(in: 10...45)
        let points = duration * 3
        
        appData.endChillSession(durationMinutes: duration, pointsEarned: points)
        appData.addPoints(points, showAnimation: true)
        
        print("✅ Session ended: \(duration)min, +\(points) points")
    }
    
    private func refreshData() async {
        // Simulate refresh delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Refresh online status (demo purposes)
        for i in appData.friends.indices {
            appData.friends[i].isOnline = Bool.random()
        }
        
        print("🔄 Data refreshed")
    }
}

// MARK: - Quick Stat Item Component
struct QuickStatItem: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.callout)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(Typography.headline)
                    .foregroundColor(Colors.textPrimary)
                
                Text(title)
                    .font(Typography.caption)
                    .foregroundColor(Colors.textSecondary)
            }
        }
    }
}

// MARK: - Online Friend Card Component
struct OnlineFriendCard: View {
    let friend: Friend
    let onChillTap: () -> Void
    
    var body: some View {
        VStack(spacing: Spacing.sm) {
            // Friend Info
            VStack(spacing: Spacing.xs) {
                ZStack {
                    Circle()
                        .fill(Colors.primaryGradient)
                        .frame(width: 40, height: 40)
                    
                    Text(friend.name.prefix(1).uppercased())
                        .font(Typography.callout)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    // Online indicator
                    Circle()
                        .fill(Colors.success)
                        .frame(width: 10, height: 10)
                        .offset(x: 15, y: -15)
                }
                
                Text(friend.name.components(separatedBy: " ").first ?? friend.name)
                    .font(Typography.caption)
                    .foregroundColor(Colors.textPrimary)
                    .lineLimit(1)
            }
            
            // Chill Button
            Button(action: onChillTap) {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "play.fill")
                        .font(.caption)
                    Text("Chill")
                        .font(Typography.caption)
                }
                .foregroundColor(.white)
                .padding(.horizontal, Spacing.sm)
                .padding(.vertical, 4)
                .background(Colors.primary)
                .cornerRadius(Radius.sm)
            }
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

// MARK: - Today Challenge Row Component
struct TodayChallengeRow: View {
    let challenge: Challenge
    
    private var progress: Double {
        return min(Double(challenge.currentProgress) / Double(challenge.targetValue), 1.0)
    }
    
    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: challenge.icon)
                .font(.caption)
                .foregroundColor(challenge.colorValue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(challenge.title)
                    .font(Typography.caption)
                    .foregroundColor(Colors.textPrimary)
                
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: challenge.colorValue))
                    .scaleEffect(y: 1.2)
            }
            
            Text("\(challenge.currentProgress)/\(challenge.targetValue)")
                .font(Typography.caption)
                .foregroundColor(Colors.textSecondary)
                .frame(minWidth: 30)
        }
    }
}

// MARK: - Mini Stat Card Component
struct MiniStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Spacing.sm) {
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
        .padding(Spacing.md)
        .background(Colors.cardBackground)
        .cornerRadius(Radius.md)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.md)
                .stroke(Colors.separator, lineWidth: 0.5)
        )
    }
}

#Preview {
    HomeView()
        .environmentObject(AppData())
}