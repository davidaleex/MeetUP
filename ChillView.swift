import SwiftUI

struct ChillView: View {
    @State private var isChilling = false
    @State private var currentPoints = 0
    @State private var sessionTime = 0
    @State private var timer: Timer?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                if isChilling {
                    activeChillSession
                } else {
                    inactiveChillState
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Chill")
            .background(
                LinearGradient(
                    gradient: Gradient(colors: isChilling ? [.purple.opacity(0.1), .blue.opacity(0.1)] : [.gray.opacity(0.05), .clear]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
    }
    
    private var activeChillSession: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("Du chillst gerade mit")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Text("Anna & Max")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(Color.purple.opacity(0.2), lineWidth: 8)
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(sessionTime % 60) / 60.0)
                        .stroke(
                            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 200, height: 200)
                        .rotationEffect(Angle(degrees: -90))
                    
                    VStack(spacing: 4) {
                        Text(timeString(from: sessionTime))
                            .font(.system(size: 28, weight: .bold, design: .monospaced))
                            .foregroundColor(.primary)
                        
                        Text("Minuten")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                VStack(spacing: 8) {
                    Text("Punkte gesammelt")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("\(currentPoints)")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.purple)
                }
            }
            
            VStack(spacing: 12) {
                Button(action: stopChillSession) {
                    HStack {
                        Image(systemName: "stop.fill")
                        Text("Session beenden")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
                }
                
                Text("Du erhältst 1 Punkt pro Minute")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var inactiveChillState: some View {
        VStack(spacing: 32) {
            VStack(spacing: 16) {
                Image(systemName: "person.2.circle")
                    .font(.system(size: 80))
                    .foregroundColor(.gray)
                
                Text("Keine aktive Session")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Treffe dich mit Freunden und starte eine Chill-Session um Punkte zu sammeln!")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 16) {
                Button(action: startChillSession) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Session mit Anna & Max starten")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(12)
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Neue Session erstellen")
                    }
                    .font(.subheadline)
                    .foregroundColor(.purple)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private func startChillSession() {
        isChilling = true
        currentPoints = 0
        sessionTime = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            sessionTime += 1
            if sessionTime % 60 == 0 {
                currentPoints += 1
            }
        }
    }
    
    private func stopChillSession() {
        isChilling = false
        timer?.invalidate()
        timer = nil
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

#Preview {
    ChillView()
}