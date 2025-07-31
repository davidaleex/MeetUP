import SwiftUI

struct ChallengesView: View {
    @EnvironmentObject var appData: AppData
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    weeklyProgressHeader
                    challengesSection
                    weeklyStatsSection
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Challenges")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private var weeklyProgressHeader: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Diese Woche")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Woche vom \(formattedWeekStart)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(completedChallengesCount)/\(appData.challenges.count)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                    
                    Text("abgeschlossen")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Overall Progress Bar
            VStack(spacing: 8) {
                HStack {
                    Text("Wöchentlicher Fortschritt")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(Int(overallProgress * 100))%")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.purple)
                }
                
                ProgressView(value: overallProgress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var challengesSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Aktuelle Challenges")
                    .font(.headline)
                Spacer()
            }
            
            LazyVStack(spacing: 12) {
                ForEach(appData.challenges) { challenge in
                    ChallengeCard(challenge: challenge)
                }
            }
        }
    }
    
    private var weeklyStatsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Wöchentliche Statistiken")
                    .font(.headline)
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                WeeklyStatCard(
                    title: "Sessions",
                    value: "\(appData.weeklyStats.sessionsCount)",
                    icon: "play.circle.fill",
                    color: .blue
                )
                
                WeeklyStatCard(
                    title: "Minuten",
                    value: "\(appData.weeklyStats.totalMinutes)",
                    icon: "timer",
                    color: .orange
                )
                
                WeeklyStatCard(
                    title: "Freunde",
                    value: "\(appData.weeklyStats.uniqueFriendsCount)",
                    icon: "person.3.fill",
                    color: .green
                )
                
                WeeklyStatCard(
                    title: "Punkte",
                    value: "\(appData.weeklyStats.pointsEarned)",
                    icon: "star.fill",
                    color: .yellow
                )
            }
        }
    }
    
    // MARK: - Computed Properties
    private var formattedWeekStart: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: appData.weeklyStats.weekStart)
    }
    
    private var completedChallengesCount: Int {
        return appData.challenges.filter { $0.isCompleted }.count
    }
    
    private var overallProgress: Double {
        let totalChallenges = appData.challenges.count
        guard totalChallenges > 0 else { return 0 }
        
        let totalProgress = appData.challenges.reduce(0) { result, challenge in
            result + challenge.progressPercentage
        }
        
        return totalProgress / Double(totalChallenges)
    }
}

struct ChallengeCard: View {
    let challenge: Challenge
    
    var progressColor: Color {
        switch challenge.color {
        case "purple": return .purple
        case "orange": return .orange
        case "green": return .green
        case "blue": return .blue
        case "red": return .red
        default: return .purple
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                // Challenge Icon
                ZStack {
                    Circle()
                        .fill(progressColor.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: challenge.icon)
                        .font(.title2)
                        .foregroundColor(progressColor)
                }
                
                // Challenge Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(challenge.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(challenge.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Completion Status
                if challenge.isCompleted {
                    ZStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: "checkmark")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                } else {
                    VStack(spacing: 2) {
                        Text("\(challenge.currentProgress)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(progressColor)
                        
                        Text("/ \(challenge.targetValue)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Progress Bar
            VStack(spacing: 8) {
                HStack {
                    Text("Fortschritt")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text("\(Int(challenge.progressPercentage * 100))%")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(progressColor)
                }
                
                ProgressView(value: challenge.progressPercentage)
                    .progressViewStyle(LinearProgressViewStyle(tint: progressColor))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    challenge.isCompleted ? Color.green.opacity(0.5) : Color.clear,
                    lineWidth: challenge.isCompleted ? 2 : 0
                )
        )
    }
}

struct WeeklyStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
    }
}

#Preview {
    ChallengesView()
        .environmentObject(AppData())
}