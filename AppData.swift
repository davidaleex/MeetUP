import SwiftUI
import Foundation

class AppData: ObservableObject {
    // MARK: - Persistente Speicherung mit @AppStorage
    @AppStorage("totalPoints") var totalPoints: Int = 0
    @AppStorage("pointsSoundEnabled") var pointsSoundEnabled: Bool = true
    @AppStorage("privateChillMode") var privateChillMode: Bool = false
    @AppStorage("totalChillMinutes") var totalChillMinutes: Int = 0
    @AppStorage("totalSessions") var totalSessions: Int = 0
    
    // MARK: - Published Properties
    @Published var selectedFriends: [Friend] = []
    @Published var isChilling: Bool = false
    @Published var currentSession: ChillSession?
    @Published var friends: [Friend] = []
    @Published var challenges: [Challenge] = []
    @Published var weeklyStats: WeeklyStats
    @Published var userProfile: UserProfile = UserProfile()
    
    init() {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        weeklyStats = WeeklyStats(weekStart: startOfWeek)
        
        loadData()
        setupDummyData()
        generateWeeklyChallenges()
    }
    
    // MARK: - Dummy Data Setup
    private func setupDummyData() {
        if friends.isEmpty {
            friends = [
                Friend(name: "Anna Schmidt", username: "@anna_s", totalChillMinutes: 90, isOnline: true, lastSeen: "Online", mutualFriends: 5),
                Friend(name: "Max Müller", username: "@max_m", totalChillMinutes: 75, isOnline: true, lastSeen: "Online", mutualFriends: 8),
                Friend(name: "Lisa Weber", username: "@lisa_w", totalChillMinutes: 120, isOnline: false, lastSeen: "vor 2h", mutualFriends: 3),
                Friend(name: "Tom Fischer", username: "@tom_f", totalChillMinutes: 45, isOnline: false, lastSeen: "vor 1d", mutualFriends: 12),
                Friend(name: "Sarah Klein", username: "@sarah_k", totalChillMinutes: 60, isOnline: true, lastSeen: "Online", mutualFriends: 6)
            ]
            saveData()
        }
    }
    
    // MARK: - Friend Management
    func addFriend(_ friend: Friend) {
        if !selectedFriends.contains(where: { $0.id == friend.id }) {
            selectedFriends.append(friend)
        }
    }
    
    func removeFriend(_ friend: Friend) {
        selectedFriends.removeAll { $0.id == friend.id }
    }
    
    func clearSelectedFriends() {
        selectedFriends.removeAll()
    }
    
    func updateFriendChillTime(_ friendId: UUID, minutes: Int) {
        if let index = friends.firstIndex(where: { $0.id == friendId }) {
            friends[index].totalChillMinutes += minutes
            saveData()
        }
    }
    
    // MARK: - Points & Session Management mit Gamification
    func addPoints(_ points: Int, showAnimation: Bool = true) {
        let oldLevel = userProfile.level
        
        if !privateChillMode {
            totalPoints += points
            userProfile.totalPoints = totalPoints
            
            // Prüfe Level-Up
            let newLevel = userProfile.level
            
            if showAnimation {
                // Punkte-Animation triggern
                AnimationManager.shared.triggerPointsEarned(points)
                
                // Level-Up-Animation falls neues Level erreicht
                if newLevel > oldLevel {
                    AnimationManager.shared.triggerLevelUp(newLevel: newLevel)
                    
                    // Achievement für Level-Up
                    AnimationManager.shared.triggerAchievement(
                        title: "Level \(newLevel) erreicht!",
                        message: "Du bist jetzt \(userProfile.levelTitle)!"
                    )
                }
                
                // Spezielle Achievements prüfen
                checkSpecialAchievements(points: points, newLevel: newLevel)
            }
        }
    }
    
    /// Prüft und triggert spezielle Achievements
    private func checkSpecialAchievements(points: Int, newLevel: Int) {
        // Erste 100 Punkte Achievement
        if totalPoints >= 100 && totalPoints - points < 100 {
            AnimationManager.shared.triggerAchievement(
                title: "Erste Hundred! 🎯",
                message: "Du hast deine ersten 100 Punkte gesammelt!"
            )
        }
        
        // 500 Punkte Milestone
        if totalPoints >= 500 && totalPoints - points < 500 {
            AnimationManager.shared.triggerAchievement(
                title: "Chill Master! 🌟",
                message: "500 Punkte - Du bist ein echter Profi!"
            )
            AnimationManager.shared.triggerConfetti()
        }
        
        // 1000 Punkte Milestone
        if totalPoints >= 1000 && totalPoints - points < 1000 {
            AnimationManager.shared.triggerAchievement(
                title: "Legende! 👑",
                message: "1000 Punkte - Absolute Perfektion!"
            )
            AnimationManager.shared.triggerConfetti()
        }
        
        // Level 5 Achievement
        if newLevel == 5 {
            AnimationManager.shared.triggerAchievement(
                title: "High Five! ✋",
                message: "Level 5 erreicht - Du rockst das!"
            )
        }
        
        // Level 10 Achievement
        if newLevel == 10 {
            AnimationManager.shared.triggerAchievement(
                title: "Perfect Ten! 🔟",
                message: "Level 10 - Du bist unaufhaltbar!"
            )
            AnimationManager.shared.triggerConfetti()
        }
    }
    
    func startChillSession() {
        guard !selectedFriends.isEmpty else { return }
        
        let session = ChillSession(
            friendIds: selectedFriends.map { $0.id },
            startTime: Date(),
            isPrivate: privateChillMode,
            friendNames: selectedFriends.map { $0.name }
        )
        
        currentSession = session
        isChilling = true
    }
    
    func endChillSession(durationMinutes: Int, pointsEarned: Int) {
        guard var session = currentSession else { return }
        
        session.endTime = Date()
        session.durationMinutes = durationMinutes
        session.pointsEarned = pointsEarned
        
        if !privateChillMode {
            // Update stats
            totalChillMinutes += durationMinutes
            totalSessions += 1
            userProfile.totalChillMinutes = totalChillMinutes
            userProfile.totalSessions = totalSessions
            
            // Update friend chill times
            for friendId in session.friendIds {
                updateFriendChillTime(friendId, minutes: durationMinutes)
            }
            
            // Update weekly stats
            updateWeeklyStats(session: session)
            
            // Update challenges
            updateChallengeProgress(session: session)
        }
        
        isChilling = false
        currentSession = nil
        clearSelectedFriends()
        saveData()
    }
    
    // MARK: - Challenge System
    private func generateWeeklyChallenges() {
        if challenges.isEmpty || shouldResetWeeklyChallenges() {
            challenges = [
                Challenge(
                    title: "Social Butterfly",
                    description: "Chille mit 3 verschiedenen Freunden",
                    targetValue: 3,
                    icon: "person.3.fill",
                    color: "purple",
                    type: .differentFriends
                ),
                Challenge(
                    title: "Chill Master",
                    description: "Sammle 60 Minuten Chill-Zeit",
                    targetValue: 60,
                    icon: "timer",
                    color: "orange",
                    type: .totalMinutes
                ),
                Challenge(
                    title: "Session Hero",
                    description: "Starte 5 Chill-Sessions",
                    targetValue: 5,
                    icon: "play.circle.fill",
                    color: "green",
                    type: .sessions
                )
            ]
            saveData()
        }
    }
    
    private func updateChallengeProgress(session: ChillSession) {
        for i in 0..<challenges.count {
            switch challenges[i].type {
            case .differentFriends:
                weeklyStats.uniqueFriends.formUnion(session.friendIds)
                challenges[i].currentProgress = weeklyStats.uniqueFriendsCount
            case .totalMinutes:
                challenges[i].currentProgress = weeklyStats.totalMinutes
            case .sessions:
                challenges[i].currentProgress = weeklyStats.sessionsCount
            case .bondLevel:
                break
            }
        }
    }
    
    // MARK: - Weekly Stats
    private func updateWeeklyStats(session: ChillSession) {
        if shouldResetWeeklyStats() {
            resetWeeklyStats()
        }
        
        weeklyStats.sessionsCount += 1
        weeklyStats.totalMinutes += session.durationMinutes
        weeklyStats.uniqueFriends.formUnion(session.friendIds)
        weeklyStats.pointsEarned += session.pointsEarned
    }
    
    private func shouldResetWeeklyStats() -> Bool {
        return Date() >= Calendar.current.date(byAdding: .weekOfYear, value: 1, to: weeklyStats.weekStart) ?? Date()
    }
    
    private func shouldResetWeeklyChallenges() -> Bool {
        return shouldResetWeeklyStats()
    }
    
    private func resetWeeklyStats() {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        weeklyStats = WeeklyStats(weekStart: startOfWeek)
        generateWeeklyChallenges()
    }
    
    
    // MARK: - Computed Properties
    var selectedFriendsNames: String {
        if selectedFriends.isEmpty {
            return "niemand"
        } else if selectedFriends.count == 1 {
            return selectedFriends[0].name.components(separatedBy: " ").first ?? selectedFriends[0].name
        } else {
            let names = selectedFriends.map { $0.name.components(separatedBy: " ").first ?? $0.name }
            if names.count == 2 {
                return "\(names[0]) & \(names[1])"
            } else {
                let firstNames = names.prefix(names.count - 1).joined(separator: ", ")
                return "\(firstNames) & \(names.last ?? "")"
            }
        }
    }
    
    var topFriend: Friend? {
        return friends.sorted { $0.totalChillMinutes > $1.totalChillMinutes }.first
    }
    
    var friendsRanking: [Friend] {
        return friends.sorted { $0.totalChillMinutes > $1.totalChillMinutes }
    }
    
    // MARK: - Persistence
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(friends) {
            UserDefaults.standard.set(encoded, forKey: "friends")
        }
        if let encoded = try? JSONEncoder().encode(challenges) {
            UserDefaults.standard.set(encoded, forKey: "challenges")
        }
        if let encoded = try? JSONEncoder().encode(weeklyStats) {
            UserDefaults.standard.set(encoded, forKey: "weeklyStats")
        }
        if let encoded = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(encoded, forKey: "userProfile")
        }
    }
    
    private func loadData() {
        // Load friends
        if let data = UserDefaults.standard.data(forKey: "friends"),
           let decodedFriends = try? JSONDecoder().decode([Friend].self, from: data) {
            friends = decodedFriends
        }
        
        // Load challenges
        if let data = UserDefaults.standard.data(forKey: "challenges"),
           let decodedChallenges = try? JSONDecoder().decode([Challenge].self, from: data) {
            challenges = decodedChallenges
        }
        
        // Load weekly stats
        if let data = UserDefaults.standard.data(forKey: "weeklyStats"),
           let decodedStats = try? JSONDecoder().decode(WeeklyStats.self, from: data) {
            weeklyStats = decodedStats
        } else {
            let calendar = Calendar.current
            let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
            weeklyStats = WeeklyStats(weekStart: startOfWeek)
        }
        
        // Load user profile
        if let data = UserDefaults.standard.data(forKey: "userProfile"),
           let decodedProfile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            userProfile = decodedProfile
        }
        
        // Sync with @AppStorage values
        userProfile.totalPoints = totalPoints
        userProfile.totalChillMinutes = totalChillMinutes
        userProfile.totalSessions = totalSessions
    }
}
