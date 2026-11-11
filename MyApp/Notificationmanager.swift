//
//  Notificationmanager.swift
//  MyApp
//
//  Created by Dhay Bandar  on 29/05/1448 AH.
//

import SwiftUI
import UserNotifications

struct InAppBanner: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let body: String
}

final class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    private let center = UNUserNotificationCenter.current()

    @Published var activeBanner: InAppBanner? = nil

    override private init() {
        super.init()
        center.delegate = self
    }

    func setup() {
        center.delegate = self
        requestPermission()
    }

    func requestPermission(completion: @escaping (Bool) -> Void = { _ in }) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error {
                print("Notification permission error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func schedule(for plant: Plant) {
        center.delegate = self

        // 1) طلب الإذن فوراً للتأكد من موافقة المستخدم
        requestPermission { [weak self] granted in
            guard let self else { return }

            self.cancel(for: plant)

            let title = "My Plants 🌱"
            let body = "Time to water \(plant.name) 💧 (\(plant.water.rawValue))"

            // 2) إشعار نظام حقيقي يصل بعد 3 ثواني (يظهر على شاشة القفل ومركز الإشعارات)
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default

            let fastTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            let fastRequest = UNNotificationRequest(
                identifier: "\(plant.id.uuidString)_immediate",
                content: content,
                trigger: fastTrigger
            )
            self.center.add(fastRequest) { error in
                if let error {
                    print("Error scheduling notification: \(error)")
                }
            }

            // 3) إشعار دوري حسب الأيام المختارة
            let daysInterval = max(60, TimeInterval(plant.wateringDays.days * 24 * 60 * 60))
            let periodicTrigger = UNTimeIntervalNotificationTrigger(timeInterval: daysInterval, repeats: true)
            let periodicRequest = UNNotificationRequest(
                identifier: plant.id.uuidString,
                content: content,
                trigger: periodicTrigger
            )
            self.center.add(periodicRequest)

            // 4) بانر تفاعلي داخل التطبيق يظهر بعد 3 ثواني مباشرة (ليظهر في المعاينة والمحاكي)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                    self.activeBanner = InAppBanner(title: title, body: body)
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if self.activeBanner?.id == self.activeBanner?.id {
                            self.activeBanner = nil
                        }
                    }
                }
            }
        }
    }

    func cancel(for plant: Plant) {
        center.removePendingNotificationRequests(withIdentifiers: [
            plant.id.uuidString,
            "\(plant.id.uuidString)_immediate"
        ])
    }

    // MARK: - إظهار الإشعار حتى لو كان التطبيق في الواجهة
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge, .list])
    }
}
