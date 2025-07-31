import SwiftUI
import Foundation

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