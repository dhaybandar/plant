//
//  plantreminderapp.swift
//  MyApp
//

import SwiftUI

@main
struct PlantReminderApp: App {
    @StateObject private var store = PlantStore()

    init() {
        NotificationManager.shared.setup()
    }

    var body: some Scene {//يحدد النافذه الرئيسيه للتطبيق و يعرض كوكنتن فيو
        WindowGroup {
            ContentView()
                .environmentObject(store)// يسمح لاي واجهه بالوصول الى البيانات النباتات وتحديثها مباشره دون الحاجه لتمريرها يدويا بين الشاشات
        }
    }
}
