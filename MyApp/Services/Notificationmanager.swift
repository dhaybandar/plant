//
//  Notificationmanager.swift
//  MyApp
//
//  Created by Dhay Bandar  on 29/05/1448 AH.
//

import SwiftUI
import Combine     //لاداره تدفقات البيانات والاحداث والتفاعل مع النظام مما يسهل التحكم في التنبيهات
import UserNotifications  //المسوول الاساسي لتعامل مع التنبيهات مثل جدولتها وعرضها

struct InAppBanner: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let body: String // نموذج بيانات لافته التنبيه داخل التطبيق
}
//المسوول عن اداره التبيهات
final class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()//تضمن وجود نسخه واحد فقط من النتفكيشن منجير في كامل التطبيق
    private let center = UNUserNotificationCenter.current()//هذي الاداه الفعليه اللي رح يستخدمها لطلب الاذن وجدوله التبيهات وادراتها

    @Published var activeBanner: InAppBanner? = nil //اي تغيير في قيمته رح يحدث الواجهه لعرض او اخفاء الاشعار

    override private init() {//يمنع انشئ نسخ جديده من هذي الفئه نتفكيشن منقير من اي مكان اخر في الكود وهذا يضمن وجود نسخه واحده فقط تدير كل التبيهات
        super.init()
        center.delegate = self
    }

    func setup() {
        center.delegate = self
        requestPermission()
    } //تهيى النظام وتضممن جاهزيته لاستقبال ومعالجه الاشعارات بشكل سليم
    
    func requestPermission(completion: @escaping (Bool) -> Void = { _ in }) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error {
                print("Notification permission error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion(granted)
            }
        }
        //فاكشن تطلب اذن اليوزر لعرض التبيهات وتحدد انواع الاشعارات المسموح فيها
    }

    func schedule(for plant: Plant) {//فانكشن مسؤوله عن انشاء وتحديد توقيت وارسال التبيه الخاص بكل نبته بناء على احتياجاتها
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
            }//ينشى تنبيه فوري يعمل بعد ثلاث ثواني يسخدم لتجربه الاشعارات او التاكد من ظهورها بشكل صحيح

            // 3) إشعار دوري حسب الأيام المختارة
            let daysInterval = max(60, TimeInterval(plant.wateringDays.days * 24 * 60 * 60))
            let periodicTrigger = UNTimeIntervalNotificationTrigger(timeInterval: daysInterval, repeats: true)
            let periodicRequest = UNNotificationRequest(
                identifier: plant.id.uuidString,
                content: content,
                trigger: periodicTrigger
            )
            self.center.add(periodicRequest)//مسوول عن جدوله التبيهات الدوريه

            // يعرض النظام إشعارًا واحدًا فقط. لا ننشئ بانرًا داخل التطبيق
            // لتفادي تكرار نفس التذكير عندما يكون التطبيق مفتوحًا.
        }
    }

    func cancel(for plant: Plant) {
        center.removePendingNotificationRequests(withIdentifiers: [
            plant.id.uuidString,
            "\(plant.id.uuidString)_immediate"
        ])
    }//فانكشن مسووله عن الغاء اي اشعارات معلقه خاصه بنبته معينه

    // MARK: - إظهار الإشعار حتى لو كان التطبيق في الواجهة
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge, .list])
    }
}//فانكشن ل اظهار الاشعار
