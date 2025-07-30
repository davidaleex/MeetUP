import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    welcomeSection
                    currentPointsCard
                    lastSessionCard
                    quickStatsSection
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("MeetMe")
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Hi David! 👋")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Bereit für neue Chill-Sessions?")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var currentPointsCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.title2)
                Text("Deine Punkte")
                    .font(.headline)
                Spacer()
            }
            
            HStack {
                Text("2,847")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Text("Punkte")
                    .font(.title3)
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            HStack {
                Text("+127 heute")
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var lastSessionCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                Text("Letzte Session")
                    .font(.headline)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                    Text("Mit Anna & Max")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                }
                
                HStack {
                    Text("47 Minuten")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("• +47 Punkte")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                Text("Gestern, 19:30")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var quickStatsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Diese Woche")
                    .font(.headline)
                Spacer()
            }
            
            HStack(spacing: 16) {
                StatCard(title: "Sessions", value: "12", icon: "person.2.fill", color: .purple)
                StatCard(title: "Minuten", value: "324", icon: "timer", color: .orange)
                StatCard(title: "Freunde", value: "8", icon: "heart.fill", color: .pink)
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
    }
}

#Preview {
    HomeView()
}