import SwiftUI

struct SimpleStatsView: View {
    @EnvironmentObject var appData: AppData
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: Spacing.sectionSpacing) {
                    // Übersicht Stats
                    overviewSection
                    
                    // Wöchentliche Stats
                    weeklySection
                    
                    // Freunde Ranking
                    friendsSection
                    
                    Spacer(minLength: Spacing.xl)
                }
                .padding(.horizontal, Spacing.md)
            }
            .navigationTitle("Statistiken")
            .navigationBarTitleDisplayMode(.large)
            .background(Colors.background)
        }
    }
    
    // MARK: - Overview Section
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            Text("Übersicht")
                .font(Typography.title2)
                .foregroundColor(Colors.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.md) {
                SimpleStatCard(
                    title: "Gesamt Punkte",
                    value: "\(appData.totalPoints)",
                    icon: "flame.fill",
                    color: Colors.secondary
                )
                
                SimpleStatCard(
                    title: "Level",
                    value: "\(appData.userProfile.level)",
                    icon: "star.fill",
                    color: Colors.warning
                )
                
                SimpleStatCard(
                    title: "Sessions",
                    value: "\(appData.totalSessions)",
                    icon: "play.circle.fill",
                    color: Colors.primary
                )
                
                SimpleStatCard(
                    title: "Chill Zeit",
                    value: "\(appData.totalChillMinutes)m",
                    icon: "timer.circle.fill",
                    color: Colors.info
                )
            }
        }
        .padding(Spacing.cardPadding)
        .cardStyle()
    }
    
    // MARK: - Weekly Section
    private var weeklySection: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            Text("Diese Woche")
                .font(Typography.title2)
                .foregroundColor(Colors.textPrimary)
            
            VStack(spacing: Spacing.md) {
                WeeklyStatRow(
                    title: "Punkte gesammelt",
                    value: "\(appData.weeklyStats.pointsEarned)",
                    icon: "plus.circle.fill",
                    color: Colors.success
                )
                
                WeeklyStatRow(
                    title: "Sessions gestartet",
                    value: "\(appData.weeklyStats.sessionsCount)",
                    icon: "play.fill",
                    color: Colors.primary
                )
                
                WeeklyStatRow(
                    title: "Aktive Freunde",
                    value: "\(appData.weeklyStats.uniqueFriendsCount)",
                    icon: "person.2.fill",
                    color: Colors.info
                )
            }
        }
        .padding(Spacing.cardPadding)
        .cardStyle()
    }
    
    // MARK: - Friends Section
    private var friendsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            HStack {
                Text("Freunde Ranking")
                    .font(Typography.title2)
                    .foregroundColor(Colors.textPrimary)
                
                Spacer()
                
                NavigationLink(destination: RankingView()) {
                    Text("Alle anzeigen")
                        .font(Typography.caption)
                        .foregroundColor(Colors.primary)
                }
            }
            
            VStack(spacing: Spacing.sm) {
                ForEach(Array(appData.friendsRanking.prefix(5).enumerated()), id: \.element.id) { index, friend in
                    SimpleFriendRow(friend: friend, position: index + 1)
                }
            }
        }
        .padding(Spacing.cardPadding)
        .cardStyle()
    }
}

// MARK: - Simple Stat Card Component
struct SimpleStatCard: View {
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

// MARK: - Weekly Stat Row Component
struct WeeklyStatRow: View {
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

// MARK: - Simple Friend Row Component
struct SimpleFriendRow: View {
    let friend: Friend
    let position: Int
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            // Position
            ZStack {
                Circle()
                    .fill(positionColor.opacity(0.15))
                    .frame(width: 28, height: 28)
                
                Text("\(position)")
                    .font(Typography.caption)
                    .foregroundColor(positionColor)
                    .fontWeight(.semibold)
            }
            
            // Friend Info
            VStack(alignment: .leading, spacing: 2) {
                Text(friend.name.components(separatedBy: " ").first ?? friend.name)
                    .font(Typography.callout)
                    .foregroundColor(Colors.textPrimary)
                
                Text("\(friend.totalChillMinutes) Minuten")
                    .font(Typography.caption)
                    .foregroundColor(Colors.textSecondary)
            }
            
            Spacer()
            
            // Online Status
            if friend.isOnline {
                Circle()
                    .fill(Colors.success)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 2)
    }
    
    private var positionColor: Color {
        switch position {
        case 1: return Colors.warning
        case 2: return Colors.textSecondary
        case 3: return Colors.secondary
        default: return Colors.textSecondary
        }
    }
}

#Preview {
    SimpleStatsView()
        .environmentObject(AppData())
}