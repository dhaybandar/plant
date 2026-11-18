import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: PlantStore
    @ObservedObject private var notifications = NotificationManager.shared
    @State private var showOnboardingSheet = false//يدير حاله ظهور شاشه الاعدادات محليا

    var body: some View {
        ZStack(alignment: .top) {
            Theme.background.ignoresSafeArea()

            if store.plants.isEmpty {
                OnboardingView {
                    showOnboardingSheet = true
                }
                .transition(.opacity)//اذا كانت ليست النباتات فارغه يعرض شاشه الترحيب ويضبط حاله الاعدادات تصير نشطه
            } else {
                PlantListView()
                    .transition(.opacity)//اذا لا يعرض قائمه النباتات الحاليه
            }

            if let banner = notifications.activeBanner {
                NotificationBannerView(banner: banner) {
                    withAnimation {
                        notifications.activeBanner = nil
                    }//تقوم بتهيئه الاشعارات عند ظهور الواجهه
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
            ReminderSheet(plant: nil)//
        }
    }//يضبط ظهور ورقه التذكير 
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
