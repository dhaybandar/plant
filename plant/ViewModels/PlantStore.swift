//
//  PlantStore.swift
//  Planto
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
        NotificationManager.shared.cancelAll()
        plants.removeAll()
    }

    func add(_ plant: Plant) {
        plants.append(plant)
        NotificationManager.shared.schedule(for: plant, isNewPlant: true)
    }

    func update(_ plant: Plant) {
        guard let index = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[index] = plant
        NotificationManager.shared.schedule(for: plant, isNewPlant: false)
    }

    func delete(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
        NotificationManager.shared.cancel(for: plant)
    }

    func toggle(_ plant: Plant) {
        guard let index = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        // Toggle watering state for today (reset if already watered, or mark as watered now)
        plants[index].lastWatered = plants[index].isDoneToday ? nil : Date()
    }

    // MARK: - Persistence

    private func save() {
        do {
            let data = try JSONEncoder().encode(plants)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to encode and save plants: \(error.localizedDescription)")
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key) else { return }
        do {
            let decoded = try JSONDecoder().decode([Plant].self, from: data)
            plants = decoded
        } catch {
            print("Failed to decode saved plants: \(error.localizedDescription)")
        }
    }
}
