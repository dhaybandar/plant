import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: PlantStore
    @ObservedObject private var notifications = NotificationManager.shared
    @State private var showOnboardingSheet = false

    var body: some View {
        ZStack(alignment: .top) {
            Theme.background.ignoresSafeArea()

            if store.plants.isEmpty {
                OnboardingView {
                    showOnboardingSheet = true
                }
                .transition(.opacity)
            } else {
                PlantListView()
                    .transition(.opacity)
            }

            if let banner = notifications.activeBanner {
                NotificationBannerView(banner: banner) {
                    withAnimation {
                        notifications.activeBanner = nil
                    }
                }
                .padding(.top, 8)
                .padding(.horizontal, 16)
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(100)
            }
        }
        .onAppear {
            NotificationManager.shared.setup()
        }
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
