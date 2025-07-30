//
//  ContentView.swift
//  MeetMe
//
//  Created by David Weil on 30.07.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            ChillView()
                .tabItem {
                    Image(systemName: "timer")
                    Text("Chill")
                }
            
            FriendsView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Freunde")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profil")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .tint(.purple)
    }
}

#Preview {
    ContentView()
}
