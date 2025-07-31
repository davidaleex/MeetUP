import SwiftUI

// MARK: - Design System Extensions
extension View {
    // Card-Style mit konsistentem Design
    func cardStyle() -> some View {
        self
            .background(Colors.cardBackground)
            .cornerRadius(Radius.lg)
            .shadow(
                color: Shadow.card.color,
                radius: Shadow.card.radius,
                x: Shadow.card.x,
                y: Shadow.card.y
            )
    }
    
    // Primärer Button-Style
    func primaryButtonStyle() -> some View {
        self
            .frame(minHeight: Spacing.buttonHeight)
            .background(Colors.primaryGradient)
            .foregroundColor(.white)
            .cornerRadius(Radius.md)
            .shadow(
                color: Colors.primary.opacity(0.3),
                radius: 8,
                x: 0,
                y: 4
            )
    }
    
    // Sekundärer Button-Style
    func secondaryButtonStyle() -> some View {
        self
            .frame(minHeight: Spacing.buttonHeight)
            .background(Colors.cardBackground)
            .foregroundColor(Colors.primary)
            .cornerRadius(Radius.md)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.md)
                    .stroke(Colors.primary.opacity(0.3), lineWidth: 1)
            )
    }
    
    // Weicher Schatten
    func softShadow() -> some View {
        self.shadow(
            color: Shadow.soft.color,
            radius: Shadow.soft.radius,
            x: Shadow.soft.x,
            y: Shadow.soft.y
        )
    }
}

