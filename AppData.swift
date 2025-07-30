import SwiftUI

class AppData: ObservableObject {
    @AppStorage("totalPoints") var totalPoints: Int = 0
    @AppStorage("pointsSoundEnabled") var pointsSoundEnabled: Bool = true
    @Published var selectedFriends: [Friend] = []
    @Published var isChilling: Bool = false
    
    func addFriend(_ friend: Friend) {
        if !selectedFriends.contains(where: { $0.id == friend.id }) {
            selectedFriends.append(friend)
        }
    }
    
    func removeFriend(_ friend: Friend) {
        selectedFriends.removeAll { $0.id == friend.id }
    }
    
    func clearSelectedFriends() {
        selectedFriends.removeAll()
    }
    
    func addPoints(_ points: Int) {
        totalPoints += points
    }
    
    var selectedFriendsNames: String {
        if selectedFriends.isEmpty {
            return "niemand"
        } else if selectedFriends.count == 1 {
            return selectedFriends[0].name.components(separatedBy: " ").first ?? selectedFriends[0].name
        } else {
            let names = selectedFriends.map { $0.name.components(separatedBy: " ").first ?? $0.name }
            if names.count == 2 {
                return "\(names[0]) & \(names[1])"
            } else {
                let firstNames = names.prefix(names.count - 1).joined(separator: ", ")
                return "\(firstNames) & \(names.last!)"
            }
        }
    }
}