import SwiftUI

// MARK: - Shadow Constants für MeetMe App
struct Shadow {
    static let soft = (color: Color.black.opacity(0.06), radius: CGFloat(8), x: CGFloat(0), y: CGFloat(2))
    static let medium = (color: Color.black.opacity(0.1), radius: CGFloat(12), x: CGFloat(0), y: CGFloat(4))
    static let strong = (color: Color.black.opacity(0.15), radius: CGFloat(20), x: CGFloat(0), y: CGFloat(8))
    static let card = (color: Color.black.opacity(0.08), radius: CGFloat(10), x: CGFloat(0), y: CGFloat(3))
}