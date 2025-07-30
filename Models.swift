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

// MARK: - Chill Session Model
struct ChillSession: Identifiable, Codable {
    let id: UUID
    let friendIds: [UUID]
    let startTime: Date
    var endTime: Date?
    var durationMinutes: Int
    var pointsEarned: Int
    var isPrivate: Bool
    var friendNames: [String]
    
    init(friendIds: [UUID], startTime: Date, isPrivate: Bool = false, friendNames: [String] = []) {
        self.id = UUID()
        self.friendIds = friendIds
        self.startTime = startTime
        self.endTime = nil
        self.durationMinutes = 0
        self.pointsEarned = 0
        self.isPrivate = isPrivate
        self.friendNames = friendNames
    }
    
    var isActive: Bool {
        return endTime == nil
    }
}

// MARK: - Challenge Model
struct Challenge: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let targetValue: Int
    var currentProgress: Int
    let icon: String
    let color: String
    let type: ChallengeType
    
    init(title: String, description: String, targetValue: Int, currentProgress: Int = 0, icon: String, color: String, type: ChallengeType) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.targetValue = targetValue
        self.currentProgress = currentProgress
        self.icon = icon
        self.color = color
        self.type = type
    }
    
    var progressPercentage: Double {
        return min(1.0, Double(currentProgress) / Double(targetValue))
    }
    
    var isCompleted: Bool {
        return currentProgress >= targetValue
    }
}

enum ChallengeType: String, Codable, CaseIterable {
    case differentFriends = "different_friends"
    case totalMinutes = "total_minutes" 
    case sessions = "sessions"
    case bondLevel = "bond_level"
}

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

// MARK: - Weekly Stats Model
struct WeeklyStats: Codable {
    var weekStart: Date
    var sessionsCount: Int
    var totalMinutes: Int
    var uniqueFriends: Set<UUID>
    var pointsEarned: Int
    
    init(weekStart: Date, sessionsCount: Int = 0, totalMinutes: Int = 0, uniqueFriends: Set<UUID> = [], pointsEarned: Int = 0) {
        self.weekStart = weekStart
        self.sessionsCount = sessionsCount
        self.totalMinutes = totalMinutes
        self.uniqueFriends = uniqueFriends
        self.pointsEarned = pointsEarned
    }
    
    var uniqueFriendsCount: Int {
        return uniqueFriends.count
    }
}