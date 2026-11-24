//
//  PlantStore.swift
//  MyApp
//

import Combine
import Foundation

@MainActor
final class PlantStore: ObservableObject {
    @Published private(set) var plants: [Plant] = [] {
        didSet { save() }
    }

    private let key = "plants_v1"

    // MARK: - Initialization

    init(plants: [Plant]? = nil) {
        if let plants {
            self.plants = plants
        } else {
            load()
        }
    }

    // MARK: - Computed Properties

    var doneCount: Int {
        plants.filter(\.isDoneToday).count
    }

    var progress: Double {
        plants.isEmpty ? 0 : Double(doneCount) / Double(plants.count)
    }

    var allDone: Bool {
        !plants.isEmpty && doneCount == plants.count
    }

    // MARK: - Actions

    func clearAll() {
        plants.removeAll()
    }

    func add(_ plant: Plant) {
        plants.append(plant)
        NotificationManager.shared.schedule(for: plant)
    }

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
        // تبديل حالة الري لليوم الحالي (إلغاء إذا كانت مروية، أو تسجيل وقت الري الآن)
        plants[index].lastWatered = plants[index].isDoneToday ? nil : Date()
    }

    // MARK: - Persistence

    private func save() {
        guard let data = try? JSONEncoder().encode(plants) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Plant].self, from: data) else {
            UserDefaults.standard.set(false, forKey: "hasOnboarded")
            return
        }

        plants = decoded
        if plants.isEmpty {
            UserDefaults.standard.set(false, forKey: "hasOnboarded")
        }
    }
}
