import SwiftUI
import Foundation

// MARK: - User Profile Model
struct UserProfile: Codable {
    var username: String
    var totalPoints: Int
    var totalChillMinutes: Int
    var totalSessions: Int
    var joinDate: Date
    
    init(username: String = "David", totalPoints: Int = 0, totalChillMinutes: Int = 0, totalSessions: Int = 0, joinDate: Date = Date()) {
        self.username = username
        self.totalPoints = totalPoints
        self.totalChillMinutes = totalChillMinutes
        self.totalSessions = totalSessions
        self.joinDate = joinDate
    }
    
    var level: Int {
        return max(1, totalPoints / 100) // Alle 100 Punkte ein Level
    }
    
    var levelTitle: String {
        switch level {
        case 1...5: return "Chill Anfänger"
        case 6...15: return "Social Explorer"
        case 16...30: return "Friendship Master"
        case 31...50: return "Bond Legend"
        default: return "Chill God"
        }
    }
}