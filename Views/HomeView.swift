import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appData: AppData
    @AppStorage("userFirstName") private var userFirstName: String = ""
    
    // Animation States
    @State private var pointsScale: CGFloat = 1.0
    @State private var showMotivationText = false
    @State private var currentMotivationIndex = 0
    @State private var bounceOffset: CGFloat = 0
    @State private var motivationTimer: Timer?
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: Spacing.sectionSpacing) {
                    welcomeSection
                    pointsHighlightCard
                    weeklyProgressCard
                    quickActionButtons
                    lastSessionCard
                    quickStatsSection
                    Spacer(minLength: Spacing.xl)
                }
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.xs)
            }
            .navigationTitle("MeetMe")
            .navigationBarTitleDisplayMode(.large)
            .background(Colors.background)
            .refreshable {
                await refreshData()
            }
        }
        .onAppear {
            startAnimations()
            cycleMotivationTexts()
        }
        .onDisappear {
            motivationTimer?.invalidate()
            motivationTimer = nil
        }
    }
    
    // MARK: - Welcome Section mit personalisierten Greetings
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text(Strings.Personalized.timeBasedGreeting(name: displayName))
                    .font(Typography.title1)
                    .foregroundColor(Colors.textPrimary)
                
                Text("👋")
                    .font(.title)
                    .offset(y: bounceOffset)
                    .animation(
                        Animation.easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true),
                        value: bounceOffset
                    )
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(currentMotivationText)
                    .font(Typography.callout)
                    .foregroundColor(Colors.textSecondary)
                    .opacity(showMotivationText ? 1.0 : 0.0)
                    .animation(Animation.smooth, value: showMotivationText)
                
                Text(Strings.Personalized.pointsBasedEncouragement(points: appData.totalPoints))
                    .font(Typography.caption)
                    .foregroundColor(Colors.primary)
                    .opacity(0.8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Spacing.xs)
    }
    
    // MARK: - Points Highlight Card mit Animationen
    private var pointsHighlightCard: some View {
        VStack(spacing: Spacing.lg) {
            // Header mit Icon und Titel
            HStack {
                ZStack {
                    Circle()
                        .fill(Colors.warning.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(Colors.warning)
                        .font(.title2)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Deine Punkte")
                        .font(Typography.headline)
                        .foregroundColor(Colors.textPrimary)
                    
                    Text(Strings.random(from: Strings.Motivation.achievements))
                        .font(Typography.caption)
                        .foregroundColor(Colors.textSecondary)
                }
                
                Spacer()
            }
            
            // Hauptpunktestand - große Anzeige
            HStack {
                Text("\(appData.totalPoints)")
                    .font(Typography.pointsNumber)
                    .foregroundColor(Colors.primary)
                    .scaleEffect(pointsScale)
                    .animation(AnimationConfig.bounce, value: pointsScale)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Punkte")
                        .font(Typography.title3)
                        .foregroundColor(Colors.textSecondary)
                    
                    Text("Level \(appData.userProfile.level)")
                        .font(Typography.footnote)
                        .foregroundColor(Colors.primary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Colors.primary.opacity(0.1))
                        .cornerRadius(Radius.sm)
                }
                
                Spacer()
            }
            
            // Wöchentlicher Fortschritt
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(Colors.success)
                        .font(.title3)
                    
                    Text("+\(appData.weeklyStats.pointsEarned) diese Woche")
                        .font(Typography.callout)
                        .foregroundColor(Colors.success)
                }
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.sm)
                .background(Colors.success.opacity(0.1))
                .cornerRadius(Radius.md)
                
                Spacer()
            }
        }
        .padding(Spacing.cardPadding)
        .cardStyle()
    }
    
    // MARK: - Weekly Progress Card mit Fortschrittsbalken
    private var weeklyProgressCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(Colors.info)
                    .font(.title2)
                
                Text("Wöchentlicher Fortschritt")
                    .font(Typography.headline)
                    .foregroundColor(Colors.textPrimary)
                
                Spacer()
                
                Text("\(appData.weeklyStats.sessionsCount)/7")
                    .font(Typography.footnote)
                    .foregroundColor(Colors.textSecondary)
            }
            
            // Fortschrittsbalken für Sessions
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Sessions diese Woche")
                        .font(Typography.subheadline)
                        .foregroundColor(Colors.textSecondary)
                    
                    Spacer()
                    
                    Text("\(appData.weeklyStats.sessionsCount)")
                        .font(Typography.bodyBold)
                        .foregroundColor(Colors.primary)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: Radius.xs)
                            .fill(Colors.separator.opacity(0.3))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: Radius.xs)
                            .fill(Colors.primaryGradient)
                            .frame(
                                width: geometry.size.width * min(1.0, Double(appData.weeklyStats.sessionsCount) / 7.0),
                                height: 8
                            )
                            .animation(Animation.smooth, value: appData.weeklyStats.sessionsCount)
                    }
                }
                .frame(height: 8)
            }
        }
        .padding(Spacing.cardPadding)
        .cardStyle()
    }
    
    // MARK: - Quick Action Buttons
    private var quickActionButtons: some View {
        HStack(spacing: Spacing.md) {
            Button(action: startQuickChill) {
                VStack(spacing: Spacing.sm) {
                    Image(systemName: "play.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text("Quick Chill")
                        .font(Typography.callout)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
            }
            .primaryButtonStyle()
            
            Button(action: findFriends) {
                VStack(spacing: Spacing.sm) {
                    Image(systemName: "person.2.fill")
                        .font(.title)
                        .foregroundColor(Colors.primary)
                    
                    Text("Freunde")
                        .font(Typography.callout)
                        .foregroundColor(Colors.primary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
            }
            .secondaryButtonStyle()
        }
    }
    
    // MARK: - Last Session Card überarbeitet
    private var lastSessionCard: some View {
        VStack(spacing: Spacing.md) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Colors.info.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "clock.fill")
                        .foregroundColor(Colors.info)
                        .font(.title2)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Letzte Session")
                        .font(Typography.headline)
                        .foregroundColor(Colors.textPrimary)
                    
                    Text("Deine letzten Chill-Minuten")
                        .font(Typography.caption)
                        .foregroundColor(Colors.textSecondary)
                }
                
                Spacer()
            }
            
            if let topFriend = appData.topFriend {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    HStack(spacing: Spacing.sm) {
                        // Status Indicator
                        ZStack {
                            Circle()
                                .fill(Colors.success)
                                .frame(width: 12, height: 12)
                            
                            Circle()
                                .fill(Colors.success.opacity(0.3))
                                .frame(width: 20, height: 20)
                                .scaleEffect(1.0)
                                .animation(
                                    Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: false),
                                    value: 1.0
                                )
                        }
                        
                        Text("Mit \(topFriend.name.components(separatedBy: " ").first ?? topFriend.name)")
                            .font(Typography.bodyBold)
                            .foregroundColor(Colors.textPrimary)
                        
                        Spacer()
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(topFriend.totalChillMinutes)")
                                .font(Typography.statNumber)
                                .foregroundColor(Colors.primary)
                            
                            Text("Minuten insgesamt")
                                .font(Typography.caption)
                                .foregroundColor(Colors.textSecondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            HStack(spacing: 4) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(Colors.error)
                                    .font(.caption)
                                
                                Text("Level \(topFriend.bondLevel)")
                                    .font(Typography.footnote)
                                    .foregroundColor(Colors.error)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Colors.error.opacity(0.1))
                            .cornerRadius(Radius.sm)
                            
                            Text(topFriend.bondTitle)
                                .font(Typography.caption2)
                                .foregroundColor(Colors.textSecondary)
                        }
                    }
                }
            } else {
                VStack(spacing: Spacing.sm) {
                    Image(systemName: "moon.zzz.fill")
                        .font(.largeTitle)
                        .foregroundColor(Colors.textTertiary)
                    
                    Text("Noch keine Sessions")
                        .font(Typography.headline)
                        .foregroundColor(Colors.textSecondary)
                    
                    Text("Starte deine erste Chill-Session!")
                        .font(Typography.subheadline)
                        .foregroundColor(Colors.textTertiary)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, Spacing.lg)
            }
        }
        .padding(Spacing.cardPadding)
        .cardStyle()
    }
    
    // MARK: - Quick Stats Section überarbeitet
    private var quickStatsSection: some View {
        VStack(spacing: Spacing.md) {
            HStack {
                Text("Diese Woche")
                    .font(Typography.title2)
                    .foregroundColor(Colors.textPrimary)
                
                Spacer()
                
                Button(action: viewAllStats) {
                    HStack(spacing: 4) {
                        Text("Alle anzeigen")
                            .font(Typography.footnote)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption2)
                    }
                    .foregroundColor(Colors.primary)
                }
            }
            
            HStack(spacing: Spacing.md) {
                ModernStatCard(
                    title: "Sessions",
                    value: "\(appData.weeklyStats.sessionsCount)",
                    icon: "person.2.fill",
                    color: Colors.primary,
                    subtitle: "Chill-Runden"
                )
                
                ModernStatCard(
                    title: "Minuten",
                    value: "\(appData.weeklyStats.totalMinutes)",
                    icon: "timer",
                    color: Colors.secondary,
                    subtitle: "entspannt"
                )
                
                ModernStatCard(
                    title: "Freunde",
                    value: "\(appData.weeklyStats.uniqueFriendsCount)",
                    icon: "heart.fill",
                    color: Colors.error,
                    subtitle: "gechillt"
                )
            }
        }
    }
    
    // MARK: - Helper Functions
    
    /// Zeigt den richtigen Namen an (registrierter Name oder Fallback)
    private var displayName: String {
        return !userFirstName.isEmpty ? userFirstName : appData.userProfile.username
    }
    
    /// Aktueller Motivationstext
    private var currentMotivationText: String {
        let motivations = Strings.Motivation.greetings
        return motivations.indices.contains(currentMotivationIndex) ? 
               motivations[currentMotivationIndex] : 
               motivations.first ?? "Bereit für neue Chill-Sessions?"
    }
    
    /// Startet Animationen beim View-Erscheinen
    private func startAnimations() {
        // Wave-Animation für Hand-Emoji
        bounceOffset = -3
        
        // Points Scale Animation
        pointsScale = 1.1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            pointsScale = 1.0
        }
    }
    
    /// Wechselt durch Motivationstexte
    private func cycleMotivationTexts() {
        showMotivationText = true
        
        motivationTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
            withAnimation(Animation.smooth) {
                showMotivationText = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                currentMotivationIndex = (currentMotivationIndex + 1) % Strings.Motivation.greetings.count
                
                withAnimation(Animation.smooth) {
                    showMotivationText = true
                }
            }
        }
    }
    
    /// Refresh-Funktion für Pull-to-Refresh
    private func refreshData() async {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Trigger points animation
        withAnimation(AnimationConfig.bounce) {
            pointsScale = 1.2
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(AnimationConfig.bounce) {
                pointsScale = 1.0
            }
        }
    }
    
    /// Quick Chill Action mit Points-Belohnung
    private func startQuickChill() {
        // Simuliere Punkte-Gewinn für Quick Chill
        let pointsEarned = Int.random(in: 10...25)
        appData.addPoints(pointsEarned, showAnimation: true)
        
        // Hier würde Navigation zu ChillView erfolgen
        print("Quick Chill gestartet! +\(pointsEarned) Punkte")
    }
    
    /// Find Friends Action
    private func findFriends() {
        // Hier würde Navigation zu FriendsView erfolgen
        print("Freunde suchen gestartet!")
    }
    
    /// View All Stats Action
    private func viewAllStats() {
        // Hier würde Navigation zu Stats/Leaderboard erfolgen
        print("Alle Stats anzeigen!")
    }
}

// MARK: - Modern Stat Card Component
struct ModernStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let subtitle: String
    
    @State private var animateIcon = false
    
    var body: some View {
        VStack(spacing: Spacing.sm) {
            // Icon mit Animation
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                        value: animateIcon
                    )
            }
            
            // Wert - große Anzeige
            Text(value)
                .font(Typography.statNumber)
                .foregroundColor(Colors.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            // Titel und Untertitel
            VStack(spacing: 2) {
                Text(title)
                    .font(Typography.footnote)
                    .foregroundColor(Colors.textSecondary)
                
                Text(subtitle)
                    .font(Typography.caption2)
                    .foregroundColor(Colors.textTertiary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.lg)
        .cardStyle()
        .onAppear {
            // Starte Icon-Animation nach zufälliger Verzögerung
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.1...0.8)) {
                animateIcon = true
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppData())
}