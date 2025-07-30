//
//  MeetMeApp.swift
//  MeetMe
//
//  Created by David Weil on 30.07.2025.
//

import SwiftUI

@main
struct MeetMeApp: App {
    @StateObject private var appData = AppData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appData)
        }
    }
}
