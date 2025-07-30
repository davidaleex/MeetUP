import SwiftUI

struct WelcomeView: View {
    let firstName: String
    let onContinue: () -> Void
    
    @State private var showAnimation = false
    
    // Personalisierte Welcome Messages
    private var welcomeMessage: String {
        let messages = [
            "Willkommen bei MeetMe, \(firstName)! Hier kannst du entspannte Sessions mit deinen Freunden genießen.",
            "Hey \(firstName)! Bereit für unvergessliche Chill-Momente mit deinen Liebsten?",
            "Hi \(firstName)! Lass uns zusammen die Kunst des Entspannens mit Freunden entdecken.",
            "Schön dich zu sehen, \(firstName)! Deine Reise zu mehr Quality Time beginnt jetzt."
        ]
        return messages.randomElement() ?? messages.first ?? "Willkommen bei MeetMe!"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()
                
                // Willkommens-Animation und Text
                VStack(spacing: 24) {
                    // Animiertes Willkommens-Icon
                    ZStack {
                        Circle()
                            .fill(Color.purple.opacity(0.1))
                            .frame(width: 120, height: 120)
                            .scaleEffect(showAnimation ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: showAnimation)
                        
                        Image(systemName: "hand.wave.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.purple)
                            .rotationEffect(.degrees(showAnimation ? 15 : -15))
                            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: showAnimation)
                    }
                    
                    // Persönliche Begrüßung
                    VStack(spacing: 12) {
                        Text("Hallo, \(firstName)!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .opacity(showAnimation ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 1.0).delay(0.5), value: showAnimation)
                        
                        Text("Schön, dass du da bist.")
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .opacity(showAnimation ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 1.0).delay(1.0), value: showAnimation)
                    }
                    .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                // Informationstext
                VStack(spacing: 16) {
                    Text(welcomeMessage)
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                        .opacity(showAnimation ? 1.0 : 0.0)
                        .animation(DesignSystem.Animation.smooth.delay(1.5), value: showAnimation)
                    
                    // Features-Vorschau
                    HStack(spacing: 30) {
                        FeatureIcon(icon: "timer", title: "Chill", color: .orange)
                        FeatureIcon(icon: "person.2.fill", title: "Freunde", color: .blue)
                        FeatureIcon(icon: "trophy.fill", title: "Ranking", color: .yellow)
                    }
                    .opacity(showAnimation ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 1.0).delay(2.0), value: showAnimation)
                }
                
                Spacer()
                
                // Weiter-Button
                Button(action: onContinue) {
                    HStack {
                        Text("Hier geht's zur App")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .scaleEffect(showAnimation ? 1.0 : 0.8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(2.5), value: showAnimation)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
            .onAppear {
                // Animation starten wenn View erscheint
                showAnimation = true
            }
        }
    }
}

// Hilfsstruct für Feature-Icons in der Vorschau
struct FeatureIcon: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    WelcomeView(firstName: "Max") {
        print("Weiter zur App gedrückt")
    }
}