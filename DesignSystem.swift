import SwiftUI

// MARK: - Design System für MeetMe App
// Zentrale Sammlung aller Design-Konstanten für konsistentes UI/UX

struct DesignSystem {
    
    // MARK: - Farbpalette
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
    
    // MARK: - Typografie
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
    
    // MARK: - Spacing & Layout
    struct Spacing {
        static let xxxs: CGFloat = 2
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
        static let xxxl: CGFloat = 40
        static let giant: CGFloat = 48
        
        // Spezielle Abstände
        static let cardPadding: CGFloat = 20
        static let sectionSpacing: CGFloat = 24
        static let buttonHeight: CGFloat = 50 // Mindestens 44pt für Touch-Targets
        static let iconSize: CGFloat = 24
        static let tabIconSize: CGFloat = 22
    }
    
    // MARK: - Border Radius
    struct Radius {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let round: CGFloat = 50 // Für runde Buttons
    }
    
    // MARK: - Schatten
    struct Shadow {
        static let soft = (color: Color.black.opacity(0.06), radius: CGFloat(8), x: CGFloat(0), y: CGFloat(2))
        static let medium = (color: Color.black.opacity(0.1), radius: CGFloat(12), x: CGFloat(0), y: CGFloat(4))
        static let strong = (color: Color.black.opacity(0.15), radius: CGFloat(20), x: CGFloat(0), y: CGFloat(8))
        static let card = (color: Color.black.opacity(0.08), radius: CGFloat(10), x: CGFloat(0), y: CGFloat(3))
    }
    
    // MARK: - Animation Durations
    struct Animation {
        static let fast: Double = 0.2
        static let medium: Double = 0.3
        static let slow: Double = 0.5
        static let bounce = SwiftUI.Animation.spring(response: 0.6, dampingFraction: 0.7)
        static let smooth = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let quick = SwiftUI.Animation.easeOut(duration: 0.2)
    }
}

// MARK: - Design System Extensions
extension View {
    // Card-Style mit konsistentem Design
    func cardStyle() -> some View {
        self
            .background(DesignSystem.Colors.cardBackground)
            .cornerRadius(DesignSystem.Radius.lg)
            .shadow(
                color: DesignSystem.Shadow.card.color,
                radius: DesignSystem.Shadow.card.radius,
                x: DesignSystem.Shadow.card.x,
                y: DesignSystem.Shadow.card.y
            )
    }
    
    // Primärer Button-Style
    func primaryButtonStyle() -> some View {
        self
            .frame(minHeight: DesignSystem.Spacing.buttonHeight)
            .background(DesignSystem.Colors.primaryGradient)
            .foregroundColor(.white)
            .cornerRadius(DesignSystem.Radius.md)
            .shadow(
                color: DesignSystem.Colors.primary.opacity(0.3),
                radius: 8,
                x: 0,
                y: 4
            )
    }
    
    // Sekundärer Button-Style
    func secondaryButtonStyle() -> some View {
        self
            .frame(minHeight: DesignSystem.Spacing.buttonHeight)
            .background(DesignSystem.Colors.cardBackground)
            .foregroundColor(DesignSystem.Colors.primary)
            .cornerRadius(DesignSystem.Radius.md)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.md)
                    .stroke(DesignSystem.Colors.primary.opacity(0.3), lineWidth: 1)
            )
    }
    
    // Weicher Schatten
    func softShadow() -> some View {
        self.shadow(
            color: DesignSystem.Shadow.soft.color,
            radius: DesignSystem.Shadow.soft.radius,
            x: DesignSystem.Shadow.soft.x,
            y: DesignSystem.Shadow.soft.y
        )
    }
}

// MARK: - Microtexts für Personalisierung
struct Microtexts {
    
    struct Motivation {
        static let greetings = [
            "Bereit für neue Chill-Sessions?",
            "Zeit zum Entspannen mit Freunden!",
            "Deine nächste Session wartet!",
            "Lass uns chillen! 😎",
            "Heute wird ein entspannter Tag! ☀️",
            "Wie wäre es mit einer Session?",
            "Deine Freunde vermissen dich! 💙",
            "Zeit für Quality Time! ⏰"
        ]
        
        static let achievements = [
            "Du bist hier top! 🌟",
            "Fantastische Arbeit!",
            "Du rockst das! 🚀",
            "Weiter so! 💪",
            "Absolutely crushing it! 🔥",
            "Du bist eine Inspiration! ✨",
            "Legendary Performance! 👑",
            "Chill-Master in Action! 🎯"
        ]
        
        static let encouragements = [
            "Chille los!",
            "Zeit für entspannte Momente",
            "Sammle mehr Punkte mit Freunden!",
            "Deine Freunde warten schon",
            "Heute ist dein Tag! 🌈",
            "Mach's dir gemütlich! 🛋️",
            "Entspannung pur wartet! 🧘‍♀️",
            "Let's get this chill started! 🎵"
        ]
        
        static let timeSpecific = [
            "Guten Morgen! Zeit für einen entspannten Start! ☀️",
            "Perfekte Zeit für eine Mittagspause! 🌤️",
            "Der Nachmittag ruft nach Entspannung! 🌅",
            "Abends chillen ist das Beste! 🌙",
            "Wochenende = Chill-Zeit! 🎉"
        ]
    }
    
    struct Points {
        static let earned = [
            "Punkte gesammelt! 🎉",
            "Super Session! ⭐",
            "Toll gemacht! 💫",
            "Punkte sicher! ✨",
            "Nice job! 💯",
            "Perfekt! 🎯",
            "Boom! 💥",
            "Outstanding! 🏆"
        ]
        
        static let levelUp = [
            "Level Up! 🎊",
            "Neues Level erreicht! 🏆",
            "Du wirst immer besser! 📈",
            "Großartig! Nächstes Level! 🎯",
            "Evolution complete! 🦋",
            "Next level unlocked! 🔓",
            "You're on fire! 🔥",
            "Legendary upgrade! ⚡"
        ]
        
        static let milestones = [
            "Meilenstein erreicht! 🏁",
            "Das ist ein Moment für die Geschichtsbücher! 📚",
            "Unglaubliche Leistung! 🤩",
            "Du hast Geschichte geschrieben! 📜"
        ]
    }
    
    struct Session {
        static let starting = [
            "Session startet! Viel Spaß! 🎮",
            "Entspannung aktiviert! 😌",
            "Chill-Modus: AN! 🔛",
            "Quality Time begins now! ⏰",
            "Let the good vibes flow! 🌊"
        ]
        
        static let ending = [
            "Session beendet! Das war entspannend! 😊",
            "Perfekte Chill-Zeit! 💆‍♀️",
            "Mission accomplished! ✅",
            "Entspannung: Level 100! 💯",
            "That was zen! 🧘‍♂️"
        ]
    }
    
    struct Friends {
        static let bonding = [
            "Eure Freundschaft wird stärker! 💪",
            "Bond Level steigt! 📈",
            "Zusammen seid ihr unschlagbar! 👥",
            "Freundschafts-Power! ⚡",
            "Perfect Team! 🤝"
        ]
        
        static let invitations = [
            "lädt dich zu einer Session ein! 📧",
            "möchte mit dir chillen! 😎",
            "hat Zeit für eine entspannte Runde! ⏰",
            "wartet schon auf dich! 👀"
        ]
    }
    
    struct EmptyStates {
        static let noSessions = [
            "Noch keine Sessions? Zeit für die erste! 🚀",
            "Deine Chill-Reise kann beginnen! ✨",
            "Bereit für deine erste entspannte Session? 😌",
            "Lass uns mit dem Chillen anfangen! 🎯"
        ]
        
        static let noFriends = [
            "Lade deine ersten Freunde ein! 👥",
            "Teile die Entspannung mit anderen! 🌟",
            "Zusammen ist Chillen noch schöner! 💙",
            "Freunde machen alles besser! 🤗"
        ]
    }
    
    // MARK: - Personalisierte Nachrichten basierend auf Zeit/Kontext
    struct Personalized {
        /// Gibt eine Begrüßung basierend auf der Tageszeit zurück
        static func timeBasedGreeting(name: String) -> String {
            let hour = Calendar.current.component(.hour, from: Date())
            
            switch hour {
            case 5..<12:
                return "Guten Morgen, \(name)! ☀️"
            case 12..<17:
                return "Hi \(name)! 🌤️"
            case 17..<21:
                return "Schönen Abend, \(name)! 🌅"
            default:
                return "Hey \(name)! 🌙"
            }
        }
        
        /// Gibt eine motivierende Nachricht basierend auf dem Level zurück
        static func levelBasedMotivation(level: Int) -> String {
            switch level {
            case 1...3:
                return "Du fängst gerade erst an - jede große Reise beginnt mit dem ersten Schritt! 🌱"
            case 4...7:
                return "Du machst tolle Fortschritte! Keep it up! 📈"
            case 8...15:
                return "Wow, du bist schon ein echter Profi! 🏆"
            case 16...25:
                return "Du bist ein wahrer Chill-Master! Respekt! 👑"
            default:
                return "Legende! Du bist auf einem anderen Level! 🚀"
            }
        }
        
        /// Gibt eine Nachricht basierend auf Punktestand zurück
        static func pointsBasedEncouragement(points: Int) -> String {
            switch points {
            case 0..<50:
                return "Jeder Punkt zählt! Du bist auf dem richtigen Weg! 🎯"
            case 50..<200:
                return "Solide Performance! Du baust Momentum auf! ⚡"
            case 200..<500:
                return "Beeindruckend! Du zeigst echte Hingabe! 🔥"
            case 500..<1000:
                return "Absolut fantastisch! Du bist in der Spitzenliga! 🏆"
            default:
                return "Unfassbar! Du bist eine wahre Legende! 👑"
            }
        }
    }
    
    // Zufälligen Text aus Array zurückgeben
    static func random(from array: [String]) -> String {
        return array.randomElement() ?? array.first ?? ""
    }
}