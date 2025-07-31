import SwiftUI

// MARK: - Animation Constants für MeetMe App
struct AnimationConfig {
    static let fast: Double = 0.2
    static let medium: Double = 0.3
    static let slow: Double = 0.5
    static let bounce = SwiftUI.Animation.spring(response: 0.6, dampingFraction: 0.7)
    static let smooth = SwiftUI.Animation.easeInOut(duration: 0.3)
    static let quick = SwiftUI.Animation.easeOut(duration: 0.2)
}