import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var locationEnabled = true
    @State private var soundsEnabled = true
    @State private var darkModeEnabled = false
    
    var body: some View {
        NavigationStack {
            Form {
                profileSection
                preferencesSection
                privacySection
                aboutSection
                signOutSection
            }
            .navigationTitle("Einstellungen")
            .background(Color(.systemGroupedBackground))
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
                    Text("David Weil")
                        .font(.headline)
                    Text("@davidweil")
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
}