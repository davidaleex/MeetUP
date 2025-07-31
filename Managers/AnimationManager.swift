import SwiftUI
import Foundation

// MARK: - Animation Manager für Gamification-Feedback
class AnimationManager: ObservableObject {
    
    // MARK: - Published States für UI-Updates
    @Published var showPointsEarned = false
    @Published var pointsEarnedAmount = 0
    @Published var pointsEarnedPosition: CGPoint = CGPoint(x: 0, y: 0)
    
    @Published var showLevelUp = false
    @Published var newLevel = 1
    
    @Published var showAchievement = false
    @Published var achievementTitle = ""
    @Published var achievementMessage = ""
    
    @Published var showConfetti = false
    @Published var showFireworks = false
    
    // MARK: - Singleton Pattern
    static let shared = AnimationManager()
    private init() {}
    
    // MARK: - Points Animation
    /// Triggert eine Punkte-Animation mit Feedback
    func triggerPointsEarned(_ points: Int, at position: CGPoint = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)) {
        pointsEarnedAmount = points
        pointsEarnedPosition = position
        
        withAnimation(AnimationConfig.bounce) {
            showPointsEarned = true
        }
        
        // Haptic Feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Auto-hide nach 2 Sekunden
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(AnimationConfig.smooth) {
                self.showPointsEarned = false
            }
        }
        
        // Sound-Feedback (falls aktiviert)
        playPointsSound()
    }
    
    // MARK: - Level Up Animation
    /// Triggert Level-Up-Animation mit Feuerwerk
    func triggerLevelUp(newLevel: Int) {
        self.newLevel = newLevel
        
        // Haptic Feedback - stärker für Level Up
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
        
        withAnimation(AnimationConfig.bounce.delay(0.2)) {
            showLevelUp = true
            showFireworks = true
        }
        
        // Confetti nach kurzer Verzögerung
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(AnimationConfig.smooth) {
                self.showConfetti = true
            }
        }
        
        // Auto-hide nach 4 Sekunden
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            withAnimation(AnimationConfig.smooth) {
                self.showLevelUp = false
                self.showFireworks = false
                self.showConfetti = false
            }
        }
        
        playLevelUpSound()
    }
    
    // MARK: - Achievement Animation
    /// Zeigt Achievement-Popup mit Animation
    func triggerAchievement(title: String, message: String) {
        achievementTitle = title
        achievementMessage = message
        
        // Haptic Feedback
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
        
        withAnimation(AnimationConfig.bounce) {
            showAchievement = true
        }
        
        // Auto-hide nach 3 Sekunden
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(AnimationConfig.smooth) {
                self.showAchievement = false
            }
        }
        
        playAchievementSound()
    }
    
    // MARK: - Confetti Animation
    /// Triggert Confetti-Animation
    func triggerConfetti() {
        withAnimation(AnimationConfig.smooth) {
            showConfetti = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(AnimationConfig.smooth) {
                self.showConfetti = false
            }
        }
    }
    
    // MARK: - Sound Effects (optional, abhängig von AppStorage)
    private func playPointsSound() {
        // Hier würde Punkt-Sound abgespielt werden
        // Implementierung könnte mit AVAudioPlayer erfolgen
        print("🔊 Points sound played!")
    }
    
    private func playLevelUpSound() {
        print("🔊 Level up sound played!")
    }
    
    private func playAchievementSound() {
        print("🔊 Achievement sound played!")
    }
}

// MARK: - Gamification Overlay View
struct GamificationOverlay: View {
    @StateObject private var animationManager = AnimationManager.shared
    
    var body: some View {
        ZStack {
            // Points Earned Animation
            if animationManager.showPointsEarned {
                PointsEarnedView(
                    points: animationManager.pointsEarnedAmount,
                    position: animationManager.pointsEarnedPosition
                )
                .zIndex(100)
            }
            
            // Level Up Animation
            if animationManager.showLevelUp {
                LevelUpView(newLevel: animationManager.newLevel)
                    .zIndex(101)
            }
            
            // Achievement Popup
            if animationManager.showAchievement {
                AchievementPopup(
                    title: animationManager.achievementTitle,
                    message: animationManager.achievementMessage
                )
                .zIndex(102)
            }
            
            // Confetti Effect
            if animationManager.showConfetti {
                ConfettiView()
                    .zIndex(99)
            }
            
            // Fireworks Effect
            if animationManager.showFireworks {
                FireworksView()
                    .zIndex(98)
            }
        }
        .allowsHitTesting(false) // Overlay soll Touch-Events nicht blockieren
    }
}

// MARK: - Points Earned View
struct PointsEarnedView: View {
    let points: Int
    let position: CGPoint
    
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1.0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(Colors.success)
                    .font(.title2)
                
                Text("+\(points)")
                    .font(Typography.statNumber)
                    .foregroundColor(Colors.success)
            }
            
            Text(Strings.random(from: Strings.Points.earned))
                .font(Typography.caption)
                .foregroundColor(Colors.textSecondary)
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Radius.lg)
                .fill(Colors.cardBackground)
                .shadow(
                    color: Colors.success.opacity(0.3),
                    radius: 10,
                    x: 0,
                    y: 5
                )
        )
        .scaleEffect(scale)
        .opacity(opacity)
        .offset(y: offset)
        .position(position)
        .onAppear {
            // Animiere nach oben und fade out
            withAnimation(AnimationConfig.smooth.delay(0.1)) {
                offset = -50
                scale = 1.2
            }
            
            withAnimation(AnimationConfig.smooth.delay(1.5)) {
                opacity = 0.0
                offset = -100
            }
        }
    }
}

// MARK: - Level Up View
struct LevelUpView: View {
    let newLevel: Int
    
    @State private var showContent = false
    @State private var bounce = false
    
    var body: some View {
        ZStack {
            // Semi-transparent Background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: Spacing.xl) {
                // Level Up Icon
                ZStack {
                    Circle()
                        .fill(Colors.primaryGradient)
                        .frame(width: 120, height: 120)
                        .scaleEffect(bounce ? 1.2 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                            value: bounce
                        )
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
                
                // Level Up Text
                VStack(spacing: Spacing.sm) {
                    Text("LEVEL UP!")
                        .font(Typography.largeTitle)
                        .foregroundColor(.white)
                        .fontWeight(.black)
                        .opacity(showContent ? 1.0 : 0.0)
                        .scaleEffect(showContent ? 1.0 : 0.5)
                    
                    Text("Du hast Level \(newLevel) erreicht!")
                        .font(Typography.title2)
                        .foregroundColor(.white.opacity(0.9))
                        .opacity(showContent ? 1.0 : 0.0)
                    
                    Text(Strings.random(from: Strings.Points.levelUp))
                        .font(Typography.callout)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .opacity(showContent ? 1.0 : 0.0)
                }
                .animation(AnimationConfig.bounce.delay(0.5), value: showContent)
            }
        }
        .onAppear {
            showContent = true
            bounce = true
        }
    }
}

// MARK: - Achievement Popup
struct AchievementPopup: View {
    let title: String
    let message: String
    
    @State private var slideIn = false
    
    var body: some View {
        VStack {
            HStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(Colors.warning.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "trophy.fill")
                        .font(.title2)
                        .foregroundColor(Colors.warning)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(Typography.headline)
                        .foregroundColor(Colors.textPrimary)
                    
                    Text(message)
                        .font(Typography.subheadline)
                        .foregroundColor(Colors.textSecondary)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            .padding(Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .fill(Colors.cardBackground)
                    .shadow(
                        color: Colors.warning.opacity(0.3),
                        radius: 15,
                        x: 0,
                        y: 8
                    )
            )
            .offset(y: slideIn ? 0 : -200)
            .animation(AnimationConfig.bounce, value: slideIn)
            
            Spacer()
        }
        .padding(.horizontal, Spacing.md)
        .padding(.top, 100)
        .onAppear {
            slideIn = true
        }
    }
}

// MARK: - Confetti Effect
struct ConfettiView: View {
    @State private var confettiPieces: [ConfettiPiece] = []
    
    var body: some View {
        ZStack {
            ForEach(confettiPieces) { piece in
                Rectangle()
                    .fill(piece.color)
                    .frame(width: piece.size.width, height: piece.size.height)
                    .rotationEffect(.degrees(piece.rotation))
                    .position(piece.position)
                    .animation(
                        Animation.linear(duration: piece.duration)
                            .repeatForever(autoreverses: false),
                        value: piece.position
                    )
            }
        }
        .onAppear {
            generateConfetti()
        }
    }
    
    private func generateConfetti() {
        confettiPieces = (0..<50).map { _ in
            ConfettiPiece(
                color: [
                    Colors.primary,
                    Colors.secondary,
                    Colors.warning,
                    Colors.success,
                    Colors.error,
                    Colors.info
                ].randomElement() ?? Colors.primary,
                size: CGSize(
                    width: Double.random(in: 4...12),
                    height: Double.random(in: 4...12)
                ),
                position: CGPoint(
                    x: Double.random(in: 0...UIScreen.main.bounds.width),
                    y: -50
                ),
                rotation: Double.random(in: 0...360),
                duration: Double.random(in: 2...4)
            )
        }
        
        // Animate confetti falling
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for i in confettiPieces.indices {
                confettiPieces[i].position.y = UIScreen.main.bounds.height + 100
            }
        }
    }
}

// MARK: - Fireworks Effect (Simplified)
struct FireworksView: View {
    @State private var particles: [FireworkParticle] = []
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
                    .scaleEffect(particle.scale)
                    .animation(
                        Animation.easeOut(duration: particle.duration),
                        value: particle.position
                    )
            }
        }
        .onAppear {
            generateFireworks()
        }
    }
    
    private func generateFireworks() {
        let centerPoint = CGPoint(
            x: UIScreen.main.bounds.width / 2,
            y: UIScreen.main.bounds.height / 2
        )
        
        particles = (0..<30).map { i in
            let angle = Double(i) * (360.0 / 30.0) * Double.pi / 180.0
            let distance = Double.random(in: 50...150)
            
            return FireworkParticle(
                color: [
                    Colors.warning,
                    Colors.secondary,
                    Colors.error
                ].randomElement() ?? Colors.warning,
                size: Double.random(in: 4...8),
                position: centerPoint,
                opacity: 1.0,
                scale: 1.0,
                duration: Double.random(in: 1...2)
            )
        }
        
        // Animate explosion
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for i in particles.indices {
                let angle = Double(i) * (360.0 / 30.0) * Double.pi / 180.0
                let distance = Double.random(in: 50...150)
                
                particles[i].position = CGPoint(
                    x: centerPoint.x + cos(angle) * distance,
                    y: centerPoint.y + sin(angle) * distance
                )
                particles[i].opacity = 0.0
                particles[i].scale = 0.0
            }
        }
    }
}

// MARK: - Supporting Data Structures
struct ConfettiPiece: Identifiable {
    let id = UUID()
    let color: Color
    let size: CGSize
    var position: CGPoint
    let rotation: Double
    let duration: Double
}

struct FireworkParticle: Identifiable {
    let id = UUID()
    let color: Color
    let size: Double
    var position: CGPoint
    var opacity: Double
    var scale: Double
    let duration: Double
}