//
//  NotificationManager.swift
//  Planto
//
//  Created by Dhay Bandar.
//

import SwiftUI
import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    private let center = UNUserNotificationCenter.current()

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

    func schedule(for plant: Plant, isNewPlant: Bool = false) {
        center.getNotificationSettings { [weak self] settings in
            guard let self else { return }

            guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else {
                return
            }

            // Cancel any previously scheduled notifications for this plant to avoid duplicates on update
            self.cancel(for: plant)

            let title = "My Plants 🌱"
            let body = "Time to water \(plant.name) 💧 (\(plant.water.rawValue))"

            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default

            #if DEBUG
            // Immediate test notification (fires after 3 seconds) for newly created plants
            if isNewPlant {
                let fastTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                let fastRequest = UNNotificationRequest(
                    identifier: "\(plant.id.uuidString)_immediate",
                    content: content,
                    trigger: fastTrigger
                )
                self.center.add(fastRequest) { error in
                    if let error {
                        print("Error scheduling fast test notification: \(error.localizedDescription)")
                    }
                }
            }
            #endif

            // Periodic notification according to the plant's watering schedule
            let daysInterval = max(60, TimeInterval(plant.wateringDays.days * 24 * 60 * 60))
            let periodicTrigger = UNTimeIntervalNotificationTrigger(timeInterval: daysInterval, repeats: true)
            let periodicRequest = UNNotificationRequest(
                identifier: plant.id.uuidString,
                content: content,
                trigger: periodicTrigger
            )
            self.center.add(periodicRequest) { error in
                if let error {
                    print("Error scheduling periodic notification: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Cancellation

    func cancel(for plant: Plant) {
        center.removePendingNotificationRequests(withIdentifiers: [
            plant.id.uuidString,
            "\(plant.id.uuidString)_immediate"
        ])
    }

    func cancelAll() {
        center.removeAllPendingNotificationRequests()
    }

    // MARK: - UNUserNotificationCenterDelegate

    // Present notifications even while the app is in the foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge, .list])
    }
}
