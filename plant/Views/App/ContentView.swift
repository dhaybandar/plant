//
//  ContentView.swift
//  Planto
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: PlantStore
    @State private var showOnboardingSheet = false

    var body: some View {
        ZStack(alignment: .top) {
            Theme.background.ignoresSafeArea()

            if !store.hasOnboarded && store.plants.isEmpty {
                OnboardingView {
                    showOnboardingSheet = true
                }
                .transition(.opacity)
            } else {
                PlantListView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: store.hasOnboarded)
        .animation(.easeInOut, value: store.plants.isEmpty)
        .sheet(isPresented: $showOnboardingSheet) {
            ReminderSheet(plant: nil)
        }
    }
}

#Preview("Full Flow") {
    ContentView()
        .environmentObject(PlantStore(plants: []))
}

#Preview("Main Flow") {
    ContentView()
        .environmentObject(
            PlantStore(
                plants: [
                    Plant(
                        name: "Monstera",
                        room: .livingRoom,
                        light: .fullSun,
                        wateringDays: .everyDay,
                        water: .a
                    )
                ]
            )
        )
}
