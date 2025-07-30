import SwiftUI

struct FriendsView: View {
    @State private var searchText = ""
    
    let friends = [
        Friend(name: "Anna Schmidt", username: "@anna_s", points: 3245, isOnline: true, lastSeen: "Online", mutualFriends: 5),
        Friend(name: "Max Müller", username: "@max_m", points: 2156, isOnline: true, lastSeen: "Online", mutualFriends: 8),
        Friend(name: "Lisa Weber", username: "@lisa_w", points: 4521, isOnline: false, lastSeen: "vor 2h", mutualFriends: 3),
        Friend(name: "Tom Fischer", username: "@tom_f", points: 1890, isOnline: false, lastSeen: "vor 1d", mutualFriends: 12),
        Friend(name: "Sarah Klein", username: "@sarah_k", points: 2987, isOnline: true, lastSeen: "Online", mutualFriends: 6),
        Friend(name: "Alex Bauer", username: "@alex_b", points: 1654, isOnline: false, lastSeen: "vor 3h", mutualFriends: 4),
        Friend(name: "Julia Richter", username: "@julia_r", points: 3876, isOnline: false, lastSeen: "vor 5h", mutualFriends: 9),
        Friend(name: "Daniel Wolf", username: "@daniel_w", points: 2234, isOnline: true, lastSeen: "Online", mutualFriends: 7)
    ]
    
    var filteredFriends: [Friend] {
        if searchText.isEmpty {
            return friends.sorted { $0.isOnline && !$1.isOnline }
        } else {
            return friends.filter { friend in
                friend.name.localizedCaseInsensitiveContains(searchText) ||
                friend.username.localizedCaseInsensitiveContains(searchText)
            }.sorted { $0.isOnline && !$1.isOnline }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                friendsList
            }
            .navigationTitle("Freunde")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Add friend action
                    } label: {
                        Image(systemName: "person.badge.plus")
                            .foregroundColor(.purple)
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Freunde suchen...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private var friendsList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if !filteredFriends.isEmpty {
                    onlineFriendsSection
                    offlineFriendsSection
                } else {
                    emptySearchState
                }
            }
            .padding(.top, 16)
        }
    }
    
    private var onlineFriendsSection: some View {
        let onlineFriends = filteredFriends.filter { $0.isOnline }
        
        return Group {
            if !onlineFriends.isEmpty {
                VStack(spacing: 0) {
                    HStack {
                        Text("Online (\(onlineFriends.count))")
                            .font(.headline)
                            .foregroundColor(.green)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    
                    ForEach(onlineFriends) { friend in
                        FriendRow(friend: friend)
                    }
                }
            }
        }
    }
    
    private var offlineFriendsSection: some View {
        let offlineFriends = filteredFriends.filter { !$0.isOnline }
        
        return Group {
            if !offlineFriends.isEmpty {
                VStack(spacing: 0) {
                    HStack {
                        Text("Offline (\(offlineFriends.count))")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    .padding(.top, filteredFriends.filter { $0.isOnline }.isEmpty ? 0 : 24)
                    
                    ForEach(offlineFriends) { friend in
                        FriendRow(friend: friend)
                    }
                }
            }
        }
    }
    
    private var emptySearchState: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.3")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("Keine Freunde gefunden")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Versuche einen anderen Suchbegriff")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 80)
    }
}

struct FriendRow: View {
    let friend: Friend
    
    var body: some View {
        HStack(spacing: 12) {
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
            
            VStack(alignment: .leading, spacing: 2) {
                Text(friend.name)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text(friend.username)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    
                    Text("\(friend.points) Punkte")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(friend.mutualFriends) gemeinsame")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(friend.lastSeen)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Button {
                    // Invite to chill action
                } label: {
                    Text("Chillen")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(friend.isOnline ? Color.purple : Color.gray)
                        .cornerRadius(8)
                }
                .disabled(!friend.isOnline)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
        .padding(.horizontal)
        .padding(.bottom, 4)
    }
}

struct Friend: Identifiable {
    let id = UUID()
    let name: String
    let username: String
    let points: Int
    let isOnline: Bool
    let lastSeen: String
    let mutualFriends: Int
    
    var initials: String {
        let components = name.components(separatedBy: " ")
        return components.map { String($0.prefix(1)) }.joined()
    }
}

#Preview {
    FriendsView()
}
