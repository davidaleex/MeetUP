import SwiftUI
import Foundation

// MARK: - Friend Model mit Bond-Level System
struct Friend: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let username: String
    var totalChillMinutes: Int
    var isOnline: Bool
    let lastSeen: String
    let mutualFriends: Int
    
    init(name: String, username: String, totalChillMinutes: Int = 0, isOnline: Bool, lastSeen: String, mutualFriends: Int) {
        self.id = UUID()
        self.name = name
        self.username = username
        self.totalChillMinutes = totalChillMinutes
        self.isOnline = isOnline
        self.lastSeen = lastSeen
        self.mutualFriends = mutualFriends
    }
    
    // Bond-Level basierend auf Chill-Zeit
    var bondLevel: Int {
        return max(1, totalChillMinutes / 30) // Alle 30 Minuten ein Level
    }
    
    var bondTitle: String {
        switch bondLevel {
        case 1: return "Bekannte"
        case 2...5: return "Freunde"
        case 6...10: return "Gute Freunde"
        case 11...20: return "Beste Freunde"
        case 21...50: return "Vertraute"
        default: return "Seelenverwandte"
        }
    }
    
    var initials: String {
        let components = name.components(separatedBy: " ")
        return components.map { String($0.prefix(1)) }.joined()
    }
    
    static func == (lhs: Friend, rhs: Friend) -> Bool {
        return lhs.id == rhs.id
    }
}