//
//  PlantReminderApp.swift
//  Planto
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
        }
    }
}
