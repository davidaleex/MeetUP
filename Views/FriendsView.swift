import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var appData: AppData
    @State private var searchText = ""
    
    var filteredFriends: [Friend] {
        let friendsList = appData.friends
        if searchText.isEmpty {
            return friendsList.sorted { $0.isOnline && !$1.isOnline }
        } else {
            return friendsList.filter { friend in
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
                            .environmentObject(appData)
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
                            .environmentObject(appData)
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
    @EnvironmentObject var appData: AppData
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
                    Image(systemName: "timer")
                        .font(.caption)
                        .foregroundColor(.purple)
                    
                    Text("\(friend.totalChillMinutes) Min")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Level \(friend.bondLevel)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(friend.bondTitle)
                        .font(.caption)
                        .foregroundColor(.purple)
                        .fontWeight(.medium)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(friend.lastSeen)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Button {
                    toggleFriendSelection()
                } label: {
                    Text(isSelected ? "Entfernen" : "Chillen")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(buttonColor)
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
    
    private var isSelected: Bool {
        appData.selectedFriends.contains { $0.id == friend.id }
    }
    
    private var buttonColor: Color {
        if !friend.isOnline {
            return .gray
        }
        return isSelected ? .red : .purple
    }
    
    private func toggleFriendSelection() {
        if isSelected {
            appData.removeFriend(friend)
        } else {
            appData.addFriend(friend)
        }
    }
}


#Preview {
    FriendsView()
        .environmentObject(AppData())
}
