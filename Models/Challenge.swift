import SwiftUI
import Foundation

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
    
    /// Konvertiert den color String zu SwiftUI Color
    var colorValue: Color {
        switch color.lowercased() {
        case "purple":
            return Colors.primary
        case "orange":
            return Colors.secondary
        case "green":
            return Colors.success
        case "blue":
            return Colors.info
        case "red":
            return Colors.error
        case "yellow":
            return Colors.warning
        default:
            return Colors.primary
        }
    }
}

enum ChallengeType: String, Codable, CaseIterable {
    case differentFriends = "different_friends"
    case totalMinutes = "total_minutes" 
    case sessions = "sessions"
    case bondLevel = "bond_level"
}