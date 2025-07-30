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
                VStack(spacing: DesignSystem.Spacing.xxxl) {
                    // Header mit modernem Design
                    VStack(spacing: DesignSystem.Spacing.xl) {
                        ZStack {
                            Circle()
                                .fill(DesignSystem.Colors.primaryGradient.opacity(0.1))
                                .frame(width: 120, height: 120)
                                .scaleEffect(bounceIcon ? 1.1 : 1.0)
                                .animation(
                                    Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                                    value: bounceIcon
                                )
                            
                            Image(systemName: "person.crop.circle.fill.badge.plus")
                                .font(.system(size: 60))
                                .foregroundColor(DesignSystem.Colors.primary)
                        }
                        .opacity(showContent ? 1.0 : 0.0)
                        .scaleEffect(showContent ? 1.0 : 0.8)
                        .animation(DesignSystem.Animation.bounce.delay(0.2), value: showContent)
                        
                        VStack(spacing: DesignSystem.Spacing.md) {
                            Text("Willkommen bei MeetMe!")
                                .font(DesignSystem.Typography.largeTitle)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                                .multilineTextAlignment(.center)
                                .opacity(showContent ? 1.0 : 0.0)
                                .animation(DesignSystem.Animation.smooth.delay(0.4), value: showContent)
                            
                            Text("Lass uns dich kennenlernen. Wie sollen wir dich nennen?")
                                .font(DesignSystem.Typography.callout)
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, DesignSystem.Spacing.lg)
                                .opacity(showContent ? 1.0 : 0.0)
                                .animation(DesignSystem.Animation.smooth.delay(0.6), value: showContent)
                        }
                    }
                    .padding(.top, DesignSystem.Spacing.giant)
                    
                    // Eingabefelder in Card
                    VStack(spacing: DesignSystem.Spacing.lg) {
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
                    .padding(DesignSystem.Spacing.cardPadding)
                    .cardStyle()
                    .opacity(showContent ? 1.0 : 0.0)
                    .animation(DesignSystem.Animation.smooth.delay(0.8), value: showContent)
                    
                    // Registrieren Button
                    Button(action: handleRegistration) {
                        HStack(spacing: DesignSystem.Spacing.sm) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                            
                            Text("Registrieren")
                                .font(DesignSystem.Typography.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(DesignSystem.Spacing.md)
                    }
                    .primaryButtonStyle()
                    .disabled(!isFormValid)
                    .scaleEffect(isFormValid ? 1.0 : 0.95)
                    .opacity(isFormValid ? 1.0 : 0.6)
                    .animation(DesignSystem.Animation.quick, value: isFormValid)
                    .opacity(showContent ? 1.0 : 0.0)
                    .animation(DesignSystem.Animation.smooth.delay(1.0), value: showContent)
                    
                    Spacer(minLength: DesignSystem.Spacing.xxxl)
                }
                .padding(.horizontal, DesignSystem.Spacing.lg)
            }
            .background(DesignSystem.Colors.background)
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
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            HStack(spacing: DesignSystem.Spacing.xs) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.primary)
                
                Text(title)
                    .font(DesignSystem.Typography.callout)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .fontWeight(.medium)
            }
            
            TextField(placeholder, text: $text)
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .padding(DesignSystem.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.Radius.md)
                        .fill(DesignSystem.Colors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignSystem.Radius.md)
                                .stroke(
                                    isFocused ? DesignSystem.Colors.primary : DesignSystem.Colors.separator,
                                    lineWidth: isFocused ? 2 : 1
                                )
                        )
                )
                .focused($isFocused)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.words)
                .animation(DesignSystem.Animation.quick, value: isFocused)
        }
    }
}

#Preview {
    RegistrationView { firstName, lastName in
        print("Registriert: \(firstName) \(lastName)")
    }
}