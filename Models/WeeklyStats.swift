import SwiftUI
import Foundation

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