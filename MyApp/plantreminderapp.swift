//
//  plantreminderapp.swift
//  MyApp
//
//  Created by Dhay Bandar  on 29/05/1448 AH.
//
import SwiftUI
 
@main
struct PlantReminderApp: App {
    @StateObject private var store = PlantStore()
 
    init() {
        NotificationManager.shared.setup()
    }
 
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .preferredColorScheme(.dark)         }
    }
}
 
