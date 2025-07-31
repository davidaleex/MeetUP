import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appData: AppData
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    profileHeader
                    statsSection
                    achievementsSection
                    recentActivitySection
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Bearbeiten") {
                        // Edit action
                    }
                    .foregroundColor(.purple)
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.purple, .blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                    
                    Text("DW")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 4) {
                    Text("@\(appData.userProfile.username)")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(appData.userProfile.levelTitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack(spacing: 32) {
                ProfileStat(number: "\(appData.totalPoints)", label: "Punkte")
                ProfileStat(number: "\(appData.totalSessions)", label: "Sessions")
                ProfileStat(number: "\(appData.friends.count)", label: "Freunde")
            }
            
            HStack(spacing: 16) {
                Text("💫 Level \(appData.userProfile.level)")
                Text("•")
                    .foregroundColor(.secondary)
                if let topFriend = appData.topFriend {
                    Text("👑 Top Friend: \(topFriend.name.components(separatedBy: " ").first ?? topFriend.name)")
                } else {
                    Text("🌟 Bereit für neue Freundschaften")
                }
            }
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.purple.opacity(0.1))
                .foregroundColor(.purple)
                .cornerRadius(20)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var statsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Statistiken")
                    .font(.headline)
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ProfileStatCard(title: "Diese Woche", value: "\(appData.weeklyStats.pointsEarned)", subtitle: "Punkte", color: .green)
                ProfileStatCard(title: "Sessions", value: "\(appData.weeklyStats.sessionsCount)", subtitle: "diese Woche", color: .blue)
                ProfileStatCard(title: "Chill-Zeit", value: "\(appData.totalChillMinutes)", subtitle: "Minuten", color: .orange)
                ProfileStatCard(title: "Level", value: "\(appData.userProfile.level)", subtitle: "erreicht", color: .purple)
            }
        }
    }
    
    private var achievementsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Errungenschaften")
                    .font(.headline)
                Spacer()
                Button("Alle anzeigen") {
                    // Show all achievements
                }
                .font(.subheadline)
                .foregroundColor(.purple)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    AchievementBadge(emoji: "🎯", title: "Erste Session", isUnlocked: true)
                    AchievementBadge(emoji: "🔥", title: "3 Tage Streak", isUnlocked: true)
                    AchievementBadge(emoji: "⭐", title: "1000 Punkte", isUnlocked: true)
                    AchievementBadge(emoji: "👥", title: "10 Freunde", isUnlocked: true)
                    AchievementBadge(emoji: "💎", title: "VIP Status", isUnlocked: false)
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var recentActivitySection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Letzte Aktivitäten")
                    .font(.headline)
                Spacer()
            }
            
            VStack(spacing: 12) {
                ActivityRow(
                    icon: "star.fill",
                    title: "Session mit Anna & Max",
                    subtitle: "47 Minuten • +47 Punkte",
                    time: "Gestern",
                    color: .yellow
                )
                
                ActivityRow(
                    icon: "person.badge.plus",
                    title: "Neuer Freund: Lisa",
                    subtitle: "Willkommen im Team!",
                    time: "2 Tage",
                    color: .green
                )
                
                ActivityRow(
                    icon: "trophy.fill",
                    title: "Level 12 erreicht",
                    subtitle: "Keep going! 🚀",
                    time: "3 Tage",
                    color: .purple
                )
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
        }
    }
}

struct ProfileStat: View {
    let number: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(number)
                .font(.title2)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct ProfileStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
    }
}

struct AchievementBadge: View {
    let emoji: String
    let title: String
    let isUnlocked: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Text(emoji)
                .font(.title)
                .opacity(isUnlocked ? 1.0 : 0.3)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isUnlocked ? .primary : .secondary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80, height: 80)
        .background(isUnlocked ? Color.yellow.opacity(0.1) : Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct ActivityRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let time: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(time)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppData())
}