//
//  PlantStore.swift
//  MyApp
//

import Combine//لاداره تدفق البيانات وتحديث الواجهه تلقائيا عند تغير البيانات
import Foundation//يوفر الاساسيات مثل انواع البيانات والتعامل مع الملفات للحفظ والتحميل

@MainActor
final class PlantStore: ObservableObject {
    @Published private(set) var plants: [Plant] = [] {
        didSet { save() }//يدير ليست النباتات ويجعلها متاحه للواجهه لتعرضها بناء على ماسجله اليوز
    }

    private let key = "plants_v1"//يحدد مفتح التخزين

    init(plants: [Plant]? = nil) {
        if let plants {
            self.plants = plants
        } else {
            load()
        }
    }//يقوم بتهيئه قائمه البيانات ف اذا تسجل بيانات جديده يثت اعتمادها والا يتم استدعاء فانكشن التحميل لجلب البيانات المخزنه مسبقا

    var doneCount: Int {
        plants.filter(\.isDoneToday).count
    }//تحسب عدد البيانات اللي تم ريها اليوم

    var progress: Double {
        plants.isEmpty ? 0 : Double(doneCount) / Double(plants.count)
    }//يحسب نسبه الانجاز المئويه لري النباتات يقسم عدد النباتات الي تم ريها على الاجمالي لتحديد مستوى التقدم

    var allDone: Bool {
        !plants.isEmpty && doneCount == plants.count
    }//يرجع ترو اذا كانت الليست تحتوي على نباتات وتم ريها كلها اما اذا كانت فارغه فولس

    func clearAll() {
        plants.removeAll()
    }

    func add(_ plant: Plant) {
        plants.append(plant)
        NotificationManager.shared.schedule(for: plant)
    }//تضيف النبته الجديده الى اللست وتستدعي مدير الاشعارات لجدوله التبيهات الخاصه فيها

    func update(_ plant: Plant) {
        guard let index = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[index] = plant
        NotificationManager.shared.schedule(for: plant)
    }

    func delete(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
        NotificationManager.shared.cancel(for: plant)
    }

    func toggle(_ plant: Plant) {
        guard let index = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[index].lastWatered = plants[index].isDoneToday ? nil : Date()
    }//حاله ري النبته اذا كان تم ريها تلغي تسجيل ذلك وتجعلها مرويه واذا ماتم ريها تسجل وقت ريها الحالي

    private func save() {
        guard let data = try? JSONEncoder().encode(plants) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }//فانكشن تقوم بتحويل ليست النباتات الى بيانات جيسون واذا نجحت العمليه تقوم بحفط البيانات

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Plant].self, from: data) else {
            UserDefaults.standard.set(false, forKey: "hasOnboarded")
            return
        }//فانكشن تقوم بقراه البيانات المحفوظه من اليوزر ديفولت ومحاوله فك تشفيرها لاستعاده ليست البيانات السابقه اذا فشلت العمليه تعيد ضبط حاله بدء التشغيل واذا نحجت يتم تحديث الليست بالبيانات المسترده

        plants = decoded
        if plants.isEmpty {
            UserDefaults.standard.set(false, forKey: "hasOnboarded")
        }
    }
}
