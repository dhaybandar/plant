//
//  Notificationmanager.swift
//  MyApp
//
//  Created by Dhay Bandar on 29/05/1448 AH.
//

import SwiftUI
import Combine
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

    // MARK: - Setup & Authorization

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

    // MARK: - Scheduling

    func schedule(for plant: Plant) {
        center.delegate = self

        requestPermission { [weak self] granted in
            guard let self else { return }

            // إلغاء أي إشعار مجدول سابق لنفس النبتة لتفادي التكرار عند التعديل
            self.cancel(for: plant)

            let title = "My Plants 🌱"
            let body = "Time to water \(plant.name) 💧 (\(plant.water.rawValue))"

            // إشعار تجريبي سريع (بعد 3 ثوانٍ) للتحقق من ظهور الإشعارات
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

            // إشعار دوري حسب جدول الري المحدد للنبتة
            let daysInterval = max(60, TimeInterval(plant.wateringDays.days * 24 * 60 * 60))
            let periodicTrigger = UNTimeIntervalNotificationTrigger(timeInterval: daysInterval, repeats: true)
            let periodicRequest = UNNotificationRequest(
                identifier: plant.id.uuidString,
                content: content,
                trigger: periodicTrigger
            )
            self.center.add(periodicRequest)
        }
    }

    // MARK: - Cancellation

    func cancel(for plant: Plant) {
        center.removePendingNotificationRequests(withIdentifiers: [
            plant.id.uuidString,
            "\(plant.id.uuidString)_immediate"
        ])
    }

    // MARK: - UNUserNotificationCenterDelegate

    // عرض الإشعار حتى أثناء فتح التطبيق في الواجهة
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge, .list])
    }
}
