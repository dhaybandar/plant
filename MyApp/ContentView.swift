//
//  ContentView.swift
//  MyApp
//
//  Created by Dhay Bandar on 29/05/1448 AH.
//

import SwiftUI

// MARK: - Root View: يربط الواجهات ببعضها

struct ContentView: View {
    @EnvironmentObject var store: PlantStore
    @ObservedObject var notifications = NotificationManager.shared
    @State private var showOnboardingSheet = false

    var body: some View {
        ZStack(alignment: .top) {
            Theme.background.ignoresSafeArea()

            if store.plants.isEmpty {
                // 1) أول صفحة تظهر للمستخدم عند فتح التطبيق
                OnboardingView {
                    showOnboardingSheet = true
                }
                .transition(.opacity)
            } else {
                // 2) قائمة النباتات والتذكيرات اليومية
                PlantListView()
                    .transition(.opacity)
            }

            // بانر الإشعار التفاعلي عند وصول التنبيه
            if let banner = notifications.activeBanner {
                NotificationBannerView(banner: banner) {
                    withAnimation { notifications.activeBanner = nil }
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

#Preview("Full Flow (From Start)") {
    ContentView()
        .environmentObject(PlantStore(plants: []))
        .preferredColorScheme(.dark)
}

#Preview("Main Flow (With Plants)") {
    ContentView()
        .environmentObject(PlantStore(plants: [
            Plant(name: "Monstera", room: .livingRoom, light: .fullSun, wateringDays: .everyDay, water: .a)
        ]))
        .preferredColorScheme(.dark)
}
