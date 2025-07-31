import SwiftUI

// MARK: - Farbpalette für MeetMe App
struct Colors {
    // Primärfarben - Lila/Purple Theme
    static let primary = Color(red: 0.58, green: 0.40, blue: 0.98) // #9466FA
    static let primaryLight = Color(red: 0.67, green: 0.52, blue: 0.99) // #AB85FC
    static let primaryDark = Color(red: 0.45, green: 0.25, blue: 0.85) // #7340D9
    
    // Sekundärfarben - Orange/Warm
    static let secondary = Color(red: 1.0, green: 0.58, blue: 0.26) // #FF9542
    static let secondaryLight = Color(red: 1.0, green: 0.69, blue: 0.42) // #FFB06B
    static let secondaryDark = Color(red: 0.89, green: 0.45, blue: 0.13) // #E37320
    
    // Akzentfarben
    static let success = Color(red: 0.20, green: 0.78, blue: 0.35) // #34C759
    static let warning = Color(red: 1.0, green: 0.78, blue: 0.18) // #FFCC2E
    static let error = Color(red: 0.96, green: 0.26, blue: 0.21) // #F44336
    static let info = Color(red: 0.20, green: 0.67, blue: 0.95) // #33AAF2
    
    // Neutrale Farben
    static let background = Color(.systemGroupedBackground)
    static let cardBackground = Color(.systemBackground)
    static let textPrimary = Color(.label)
    static let textSecondary = Color(.secondaryLabel)
    static let textTertiary = Color(.tertiaryLabel)
    static let separator = Color(.separator)
    
    // Gradients für visuellen Appeal
    static let primaryGradient = LinearGradient(
        colors: [primary, primaryLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [secondary, secondaryLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let successGradient = LinearGradient(
        colors: [success, Color(red: 0.30, green: 0.85, blue: 0.45)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}