//
//  Notificationmanager.swift
//  MyApp
//
//  Created by Dhay Bandar  on 29/05/1448 AH.
//
import UserNotifications
 
final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    private let center = UNUserNotificationCenter.current()
 
    /// ⚠️ للتجربة: خلّها true عشان يجيك الإشعار بعد 5 ثواني
    /// (قفل الجوال بسرعة وشوف الإشعار على شاشة القفل مثل صورة الأكاديمية).
    /// للاستخدام الفعلي خلّها false.
    private let testMode = true
 
    func setup() {
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error { print("Notification auth error:", error) }
            print("Notifications granted:", granted)
        }
    }
 
    func schedule(for plant: Plant) {
        cancel(for: plant)
 
        let content = UNMutableNotificationContent()
        content.title = "Your plant 🌱"
        content.body = "Time to water \(plant.name) 💧 (\(plant.water.rawValue))"
        content.sound = .default
 
        let interval = TimeInterval(plant.wateringDays.days * 24 * 60 * 60)
 
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: testMode ? 5 : interval,
            repeats: !testMode // التكرار يحتاج interval >= 60 ثانية
        )
 
        let request = UNNotificationRequest(
            identifier: plant.id.uuidString,
            content: content,
            trigger: trigger
        )
        center.add(request)
    }
 
    func cancel(for plant: Plant) {
        center.removePendingNotificationRequests(withIdentifiers: [plant.id.uuidString])
    }
 
    // يظهر الإشعار حتى لو التطبيق مفتوح
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .list])
    }
}
