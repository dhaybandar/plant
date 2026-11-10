//
//  Models.swift
//  MyApp
//
//  Created by Dhay Bandar  on 29/05/1448 AH.
//
import SwiftUI
import Combine
 
// MARK: - Options (من صفحة "The content" في التصميم)
 
enum Room: String, CaseIterable, Codable, Identifiable {
    case bedroom = "Bedroom"
    case livingRoom = "Living Room"
    case kitchen = "Kitchen"
    case balcony = "Balcony"
    case bathroom = "Bathroom"
    var id: String { rawValue }
}
 
enum Light: String, CaseIterable, Codable, Identifiable {
    case fullSun = "Full Sun"
    case partialSun = "Partial Sun"
    case lowLight = "Low Light"
    var id: String { rawValue }
 
    var icon: String {
        switch self {
        case .fullSun: return "sun.max"
        case .partialSun: return "sun.horizon"
        case .lowLight: return "moon"
        }
    }
}
 
enum WateringDays: String, CaseIterable, Codable, Identifiable {
    case everyDay = "Every day"
    case every2 = "Every 2 days"
    case every3 = "Every 3 days"
    case weekly = "Once a week"
    case every10 = "Every 10 days"
    case every2Weeks = "Every 2 weeks"
    var id: String { rawValue }
 
    var days: Int {
        switch self {
        case .everyDay: return 1
        case .every2: return 2
        case .every3: return 3
        case .weekly: return 7
        case .every10: return 10
        case .every2Weeks: return 14
        }
    }
}
 
enum WaterAmount: String, CaseIterable, Codable, Identifiable {
    case a = "20-50 ml"
    case b = "50-100 ml"
    case c = "100-200 ml"
    case d = "200-300 ml"
    var id: String { rawValue }
}
 
// MARK: - Plant
 
struct Plant: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var room: Room = .bedroom
    var light: Light = .fullSun
    var wateringDays: WateringDays = .everyDay
    var water: WaterAmount = .a
    var lastWatered: Date? = nil
 
    /// هل انسقت النبتة اليوم؟ (يتصفّر تلقائياً كل يوم جديد)
    var isDoneToday: Bool {
        guard let lastWatered else { return false }
        return Calendar.current.isDateInToday(lastWatered)
    }
}
 
// MARK: - Store
 
final class PlantStore: ObservableObject {
    @Published var plants: [Plant] = [] {
        didSet { save() }
    }
 
    private let key = "plants_v1"
 
    init() { load() }
 
    var doneCount: Int { plants.filter(\.isDoneToday).count }
    var progress: Double {
        plants.isEmpty ? 0 : Double(doneCount) / Double(plants.count)
    }
    var allDone: Bool { !plants.isEmpty && doneCount == plants.count }
 
    func add(_ plant: Plant) {
        plants.append(plant)
        NotificationManager.shared.schedule(for: plant)
    }
 
    func update(_ plant: Plant) {
        guard let i = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[i] = plant
        NotificationManager.shared.schedule(for: plant)
    }
 
    func delete(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
        NotificationManager.shared.cancel(for: plant)
    }
 
    func toggle(_ plant: Plant) {
        guard let i = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[i].lastWatered = plants[i].isDoneToday ? nil : Date()
    }
 
    // MARK: Persistence
    private func save() {
        if let data = try? JSONEncoder().encode(plants) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
 
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Plant].self, from: data) else { return }
        plants = decoded
    }
}
