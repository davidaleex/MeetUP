import SwiftUI

struct RankingView: View {
    @EnvironmentObject var appData: AppData
    @State private var selectedSortOption: SortOption = .chillTime
    
    enum SortOption: String, CaseIterable {
        case chillTime = "Chill-Zeit"
        case bondLevel = "Bond-Level"
        case sessions = "Sessions"
        
        var icon: String {
            switch self {
            case .chillTime: return "timer"
            case .bondLevel: return "heart.fill"
            case .sessions: return "play.circle.fill"
            }
        }
    }
    
    var sortedFriends: [Friend] {
        let friends = appData.friends
        switch selectedSortOption {
        case .chillTime:
            return friends.sorted { $0.totalChillMinutes > $1.totalChillMinutes }
        case .bondLevel:
            return friends.sorted { $0.bondLevel > $1.bondLevel }
        case .sessions:
            return friends.sorted { $0.totalChillMinutes > $1.totalChillMinutes }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                sortingHeader
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if !sortedFriends.isEmpty {
                            ForEach(Array(sortedFriends.enumerated()), id: \.element.id) { index, friend in
                                RankingRow(
                                    friend: friend,
                                    rank: index + 1,
                                    sortOption: selectedSortOption
                                )
                            }
                        } else {
                            emptyState
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Best Friends")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private var sortingHeader: some View {
        VStack(spacing: 16) {
            Text("Ranking nach")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button {
                        selectedSortOption = option
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: option.icon)
                                .font(.caption)
                            Text(option.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            selectedSortOption == option ? 
                            Color.purple : Color(.systemBackground)
                        )
                        .foregroundColor(
                            selectedSortOption == option ? .white : .primary
                        )
                        .cornerRadius(20)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.3")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("Noch keine Freunde")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Starte deine ersten Chill-Sessions um ein Ranking zu erstellen!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 80)
    }
}

struct RankingRow: View {
    let friend: Friend
    let rank: Int
    let sortOption: RankingView.SortOption
    
    var rankEmoji: String {
        switch rank {
        case 1: return "🥇"
        case 2: return "🥈" 
        case 3: return "🥉"
        default: return "\(rank)"
        }
    }
    
    var primaryValue: String {
        switch sortOption {
        case .chillTime:
            return "\(friend.totalChillMinutes) Min"
        case .bondLevel:
            return "Level \(friend.bondLevel)"
        case .sessions:
            return "\(friend.totalChillMinutes / 30) Sessions"
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank Badge
            VStack {
                if rank <= 3 {
                    Text(rankEmoji)
                        .font(.title2)
                } else {
                    Text("\(rank)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 40)
            
            // Friend Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.purple, .blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Text(friend.initials)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                if friend.isOnline {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 14, height: 14)
                        .overlay(
                            Circle()
                                .stroke(Color(.systemBackground), lineWidth: 2)
                        )
                        .offset(x: 18, y: 18)
                }
            }
            
            // Friend Info
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.name)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text(friend.bondTitle)
                    .font(.subheadline)
                    .foregroundColor(.purple)
                    .fontWeight(.medium)
                
                HStack(spacing: 4) {
                    Image(systemName: "timer")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(friend.totalChillMinutes) Min gesamt")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Primary Value
            VStack(alignment: .trailing, spacing: 4) {
                Text(primaryValue)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(rank <= 3 ? .purple : .primary)
                
                if sortOption == .bondLevel {
                    Text(friend.bondTitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(rank <= 3 ? 0.1 : 0.05), radius: rank <= 3 ? 8 : 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    rank <= 3 ? Color.purple.opacity(0.3) : Color.clear,
                    lineWidth: rank <= 3 ? 2 : 0
                )
        )
    }
}

#Preview {
    RankingView()
        .environmentObject(AppData())
}