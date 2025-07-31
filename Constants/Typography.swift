import SwiftUI

// MARK: - Typografie für MeetMe App
struct Typography {
    // Überschriften
    static let largeTitle = Font.system(.largeTitle, design: .rounded, weight: .bold)
    static let title1 = Font.system(.title, design: .rounded, weight: .bold)
    static let title2 = Font.system(.title2, design: .rounded, weight: .semibold)
    static let title3 = Font.system(.title3, design: .rounded, weight: .semibold)
    
    // Fließtext
    static let headline = Font.system(.headline, design: .rounded, weight: .semibold)
    static let body = Font.system(.body, design: .default, weight: .regular)
    static let bodyBold = Font.system(.body, design: .default, weight: .semibold)
    static let callout = Font.system(.callout, design: .default, weight: .medium)
    
    // Klein- und Zusatztexte
    static let subheadline = Font.system(.subheadline, design: .default, weight: .medium)
    static let footnote = Font.system(.footnote, design: .default, weight: .regular)
    static let caption = Font.system(.caption, design: .default, weight: .regular)
    static let caption2 = Font.system(.caption2, design: .default, weight: .regular)
    
    // Spezielle Schriften für Zahlen/Stats
    static let statNumber = Font.system(.largeTitle, design: .rounded, weight: .heavy)
    static let pointsNumber = Font.system(size: 42, weight: .black, design: .rounded)
}