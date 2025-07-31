import SwiftUI

// MARK: - Microtexts für Personalisierung
struct Strings {
    
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
        
        /// Gibt eine ermutigende Nachricht basierend auf Punkten zurück
        static func pointsBasedEncouragement(points: Int) -> String {
            switch points {
            case 0...50:
                return "Sammle mehr Punkte für tolle Belohnungen! 🎯"
            case 51...200:
                return "Du bist auf einem guten Weg! 📈"
            case 201...500:
                return "Beeindruckende Punktzahl! 🌟"
            case 501...1000:
                return "Du bist ein echter Champion! 👑"
            default:
                return "Absolut legendär! Du rockst das! 🚀"
            }
        }
    }
    
    // Zufälligen Text aus Array zurückgeben
    static func random(from array: [String]) -> String {
        return array.randomElement() ?? array.first ?? ""
    }
}