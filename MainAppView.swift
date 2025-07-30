import SwiftUI

struct MainAppView: View {
    // AppStorage für lokale Datenspeicherung
    @AppStorage("userFirstName") private var userFirstName: String = ""
    @AppStorage("userLastName") private var userLastName: String = ""
    @AppStorage("hasCompletedWelcome") private var hasCompletedWelcome: Bool = false
    
    @EnvironmentObject var appData: AppData
    
    // Navigation State
    @State private var showRegistration = false
    @State private var showWelcome = false
    
    var body: some View {
        ZStack {
            Group {
                if userFirstName.isEmpty || userLastName.isEmpty {
                    // Registrierung anzeigen wenn noch keine Daten vorhanden
                    RegistrationView { firstName, lastName in
                        saveUserData(firstName: firstName, lastName: lastName)
                    }
                } else if !hasCompletedWelcome {
                    // Welcome-Screen anzeigen nach Registrierung
                    WelcomeView(firstName: userFirstName) {
                        completeWelcome()
                    }
                } else {
                    // Normale App-Navigation anzeigen
                    ContentView()
                }
            }
            .onAppear {
                // Prüfen ob Benutzerdaten bereits existieren
                checkUserStatus()
            }
            .animation(.easeInOut(duration: 0.5), value: showRegistration)
            .animation(.easeInOut(duration: 0.5), value: showWelcome)
            
            // Gamification Overlay für App-weite Animationen
            GamificationOverlay()
        }
    }
    
    // Speichert Benutzerdaten lokal
    private func saveUserData(firstName: String, lastName: String) {
        userFirstName = firstName
        userLastName = lastName
        hasCompletedWelcome = false
        
        // Optional: AppData mit Benutzerdaten aktualisieren
        updateAppDataWithUserInfo()
        
        print("Benutzerdaten gespeichert: \(firstName) \(lastName)")
    }
    
    // Markiert Welcome-Flow als abgeschlossen
    private func completeWelcome() {
        hasCompletedWelcome = true
        print("Welcome-Flow abgeschlossen für: \(userFirstName)")
    }
    
    // Prüft den aktuellen Benutzerstatus
    private func checkUserStatus() {
        print("Checking user status:")
        print("- First Name: \(userFirstName.isEmpty ? "Empty" : userFirstName)")
        print("- Last Name: \(userLastName.isEmpty ? "Empty" : userLastName)")
        print("- Has completed welcome: \(hasCompletedWelcome)")
        
        // AppData mit vorhandenen Benutzerdaten aktualisieren
        updateAppDataWithUserInfo()
    }
    
    // Aktualisiert AppData mit Benutzerinformationen
    private func updateAppDataWithUserInfo() {
        if !userFirstName.isEmpty {
            // Falls AppData einen username hat, diesen mit dem gespeicherten Namen aktualisieren
            // Dies ist optional und abhängig von der AppData-Struktur
            appData.userProfile.username = userFirstName
        }
    }
    
    // Hilfsfunktion für Debugging - zum Zurücksetzen der Registrierung
    func resetRegistration() {
        userFirstName = ""
        userLastName = ""
        hasCompletedWelcome = false
        print("Registrierung zurückgesetzt")
    }
}

#Preview {
    MainAppView()
        .environmentObject(AppData())
}