import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appData: AppData
    @State private var notificationsEnabled = true
    @State private var locationEnabled = true
    @State private var soundsEnabled = true
    @State private var darkModeEnabled = false
    @State private var showingResetAlert = false
    
    // AppStorage für Registrierungs-Reset
    @AppStorage("userFirstName") private var userFirstName: String = ""
    @AppStorage("userLastName") private var userLastName: String = ""
    @AppStorage("hasCompletedWelcome") private var hasCompletedWelcome: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                profileSection
                preferencesSection
                privacySection
                aboutSection
                signOutSection
                debugSection
            }
            .navigationTitle("Einstellungen")
            .background(Color(.systemGroupedBackground))
            .alert("Registrierung zurücksetzen", isPresented: $showingResetAlert) {
                Button("Abbrechen", role: .cancel) { }
                Button("Zurücksetzen", role: .destructive) {
                    resetRegistration()
                }
            } message: {
                Text("Möchtest du die Registrierung wirklich zurücksetzen? Du wirst beim nächsten App-Start erneut zur Registrierung geleitet.")
            }
        }
    }
    
    private var profileSection: some View {
        Section {
            HStack {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.purple, .blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Text("DW")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(appData.userProfile.username)
                        .font(.headline)
                    Text("@\(appData.userProfile.username.lowercased())")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        } header: {
            Text("Profil")
        }
    }
    
    private var preferencesSection: some View {
        Section {
            SettingsRow(
                icon: "bell.fill",
                title: "Benachrichtigungen",
                color: .orange,
                toggle: $notificationsEnabled
            )
            
            SettingsRow(
                icon: "location.fill",
                title: "Standort",
                color: .blue,
                toggle: $locationEnabled
            )
            
            SettingsRow(
                icon: "speaker.wave.2.fill",
                title: "Sounds",
                color: .green,
                toggle: $soundsEnabled
            )
            
            SettingsRow(
                icon: "moon.fill",
                title: "Dark Mode",
                color: .indigo,
                toggle: $darkModeEnabled
            )
            
            SettingsRow(
                icon: "bell.badge.fill",
                title: "Punkte-Sound",
                color: .yellow,
                toggle: $appData.pointsSoundEnabled
            )
            
            SettingsRow(
                icon: "eye.slash.fill",
                title: "Privater Chill-Modus",
                color: .purple,
                toggle: $appData.privateChillMode
            )
            
        } header: {
            Text("Einstellungen")
        }
    }
    
    private var privacySection: some View {
        Section {
            SettingsNavigationRow(
                icon: "lock.fill",
                title: "Datenschutz",
                color: .purple
            )
            
            SettingsNavigationRow(
                icon: "shield.fill",
                title: "Sicherheit",
                color: .red
            )
            
            SettingsNavigationRow(
                icon: "eye.slash.fill",
                title: "Sichtbarkeit",
                color: .gray
            )
            
        } header: {
            Text("Privatsphäre")
        }
    }
    
    private var aboutSection: some View {
        Section {
            SettingsNavigationRow(
                icon: "questionmark.circle.fill",
                title: "Hilfe & Support",
                color: .cyan
            )
            
            SettingsNavigationRow(
                icon: "doc.text.fill",
                title: "Nutzungsbedingungen",
                color: .brown
            )
            
            SettingsNavigationRow(
                icon: "info.circle.fill",
                title: "Über MeetMe",
                color: .teal
            )
            
            HStack {
                Image(systemName: "apps.iphone")
                    .foregroundColor(.secondary)
                    .frame(width: 20)
                
                Text("Version")
                
                Spacer()
                
                Text("1.0.0")
                    .foregroundColor(.secondary)
            }
            
        } header: {
            Text("Info")
        }
    }
    
    private var signOutSection: some View {
        Section {
            Button {
                // Sign out action
            } label: {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.red)
                        .frame(width: 20)
                    
                    Text("Abmelden")
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    // Debug-Sektion für Entwicklung
    private var debugSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("Registrierungs-Status:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Vorname: \(userFirstName.isEmpty ? "Nicht gesetzt" : userFirstName)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text("Nachname: \(userLastName.isEmpty ? "Nicht gesetzt" : userLastName)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text("Welcome abgeschlossen: \(hasCompletedWelcome ? "Ja" : "Nein")")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
            
            Button {
                showingResetAlert = true
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.orange)
                        .frame(width: 20)
                    
                    Text("Registrierung zurücksetzen")
                        .foregroundColor(.orange)
                }
            }
            
            // Gamification Test Buttons
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Gamification Tests:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 12) {
                    Button("Test Points") {
                        appData.addPoints(50, showAnimation: true)
                    }
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(6)
                    
                    Button("Test Achievement") {
                        AnimationManager.shared.triggerAchievement(
                            title: "Test Achievement!",
                            message: "Das ist ein Test-Achievement für das UI."
                        )
                    }
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                    .cornerRadius(6)
                }
                
                HStack(spacing: 12) {
                    Button("Test Confetti") {
                        AnimationManager.shared.triggerConfetti()
                    }
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.purple.opacity(0.1))
                    .foregroundColor(.purple)
                    .cornerRadius(6)
                    
                    Button("Big Points") {
                        appData.addPoints(200, showAnimation: true)
                    }
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(6)
                }
            }
            
        } header: {
            Text("Debug")
        } footer: {
            Text("Diese Sektion ist nur für Entwicklungszwecke verfügbar.")
        }
    }
    
    // Setzt die Registrierung zurück
    private func resetRegistration() {
        userFirstName = ""
        userLastName = ""
        hasCompletedWelcome = false
        print("Registrierung wurde zurückgesetzt")
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    @Binding var toggle: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(title)
            
            Spacer()
            
            Toggle("", isOn: $toggle)
                .labelsHidden()
        }
    }
}

struct SettingsNavigationRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(title)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppData())
}