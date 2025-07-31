import SwiftUI

struct RegistrationView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showContent = false
    @State private var bounceIcon = false
    
    // Callback für erfolgreiche Registrierung
    let onRegistrationComplete: (String, String) -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: Spacing.xxxl) {
                    // Header mit modernem Design
                    VStack(spacing: Spacing.xl) {
                        ZStack {
                            Circle()
                                .fill(Colors.primaryGradient.opacity(0.1))
                                .frame(width: 120, height: 120)
                                .scaleEffect(bounceIcon ? 1.1 : 1.0)
                                .animation(
                                    Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                                    value: bounceIcon
                                )
                            
                            Image(systemName: "person.crop.circle.fill.badge.plus")
                                .font(.system(size: 60))
                                .foregroundColor(Colors.primary)
                        }
                        .opacity(showContent ? 1.0 : 0.0)
                        .scaleEffect(showContent ? 1.0 : 0.8)
                        .animation(AnimationConfig.bounce.delay(0.2), value: showContent)
                        
                        VStack(spacing: Spacing.md) {
                            Text("Willkommen bei MeetMe!")
                                .font(Typography.largeTitle)
                                .foregroundColor(Colors.textPrimary)
                                .multilineTextAlignment(.center)
                                .opacity(showContent ? 1.0 : 0.0)
                                .animation(AnimationConfig.smooth.delay(0.4), value: showContent)
                            
                            Text("Lass uns dich kennenlernen. Wie sollen wir dich nennen?")
                                .font(Typography.callout)
                                .foregroundColor(Colors.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, Spacing.lg)
                                .opacity(showContent ? 1.0 : 0.0)
                                .animation(AnimationConfig.smooth.delay(0.6), value: showContent)
                        }
                    }
                    .padding(.top, Spacing.giant)
                    
                    // Eingabefelder in Card
                    VStack(spacing: Spacing.lg) {
                        ModernTextField(
                            title: "Vorname",
                            placeholder: "z.B. Max",
                            text: $firstName,
                            icon: "person.fill"
                        )
                        
                        ModernTextField(
                            title: "Nachname",
                            placeholder: "z.B. Mustermann",
                            text: $lastName,
                            icon: "person.badge.plus.fill"
                        )
                    }
                    .padding(Spacing.cardPadding)
                    .cardStyle()
                    .opacity(showContent ? 1.0 : 0.0)
                    .animation(AnimationConfig.smooth.delay(0.8), value: showContent)
                    
                    // Registrieren Button
                    Button(action: handleRegistration) {
                        HStack(spacing: Spacing.sm) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                            
                            Text("Registrieren")
                                .font(Typography.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(Spacing.md)
                    }
                    .primaryButtonStyle()
                    .disabled(!isFormValid)
                    .scaleEffect(isFormValid ? 1.0 : 0.95)
                    .opacity(isFormValid ? 1.0 : 0.6)
                    .animation(AnimationConfig.quick, value: isFormValid)
                    .opacity(showContent ? 1.0 : 0.0)
                    .animation(AnimationConfig.smooth.delay(1.0), value: showContent)
                    
                    Spacer(minLength: Spacing.xxxl)
                }
                .padding(.horizontal, Spacing.lg)
            }
            .background(Colors.background)
            .navigationBarHidden(true)
        }
        .alert("Registrierung", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            showContent = true
            bounceIcon = true
        }
    }
    
    // Prüft ob das Formular gültig ausgefüllt ist
    private var isFormValid: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // Behandelt die Registrierung
    private func handleRegistration() {
        let trimmedFirstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedFirstName.isEmpty && !trimmedLastName.isEmpty else {
            alertMessage = "Bitte fülle beide Felder aus."
            showingAlert = true
            return
        }
        
        // Erfolgreiche Registrierung - Callback ausführen
        onRegistrationComplete(trimmedFirstName, trimmedLastName)
    }
}

// MARK: - Modern TextField Component
struct ModernTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let icon: String
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(Colors.primary)
                
                Text(title)
                    .font(Typography.callout)
                    .foregroundColor(Colors.textPrimary)
                    .fontWeight(.medium)
            }
            
            TextField(placeholder, text: $text)
                .font(Typography.body)
                .foregroundColor(Colors.textPrimary)
                .padding(Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: Radius.md)
                        .fill(Colors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: Radius.md)
                                .stroke(
                                    isFocused ? Colors.primary : Colors.separator,
                                    lineWidth: isFocused ? 2 : 1
                                )
                        )
                )
                .focused($isFocused)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.words)
                .animation(AnimationConfig.quick, value: isFocused)
        }
    }
}

#Preview {
    RegistrationView { firstName, lastName in
        print("Registriert: \(firstName) \(lastName)")
    }
}