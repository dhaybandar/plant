//
//  Remindersheet.swift
//  MyApp
//
//  Created by Dhay Bandar  on 29/05/1448 AH.
//
import SwiftUI
 
/// صفحة Set Reminder (إضافة) + Delete / EDIT Plant (تعديل) في نفس الـ Sheet
struct ReminderSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: PlantStore
 
    private let existing: Plant?
    private let onSave: () -> Void
 
    @State private var name: String
    @State private var room: Room
    @State private var light: Light
    @State private var days: WateringDays
    @State private var water: WaterAmount
    @FocusState private var nameFocused: Bool
 
    init(plant: Plant?, onSave: @escaping () -> Void = {}) {
        self.existing = plant
        self.onSave = onSave
        _name = State(initialValue: plant?.name ?? "")
        _room = State(initialValue: plant?.room ?? .bedroom)
        _light = State(initialValue: plant?.light ?? .fullSun)
        _days = State(initialValue: plant?.wateringDays ?? .everyDay)
        _water = State(initialValue: plant?.water ?? .a)
    }
 
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
 
    var body: some View {
        ZStack {
            Theme.sheet.ignoresSafeArea()
 
            VStack(spacing: 20) {
                navBar
 
                // Plant Name
                HStack {
                    Text("Plant Name")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                    TextField("Pothos", text: $name)
                        .font(.subheadline)
                        .tint(Theme.accent)
                        .focused($nameFocused)
                        .submitLabel(.done)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(Theme.field, in: RoundedRectangle(cornerRadius: 12))
 
                // Room + Light
                VStack(spacing: 0) {
                    PickerRow(icon: "location", title: "Room", selection: $room)
                    Divider().overlay(Color(white: 0.3)).padding(.leading, 14)
                    PickerRow(icon: "sun.max", title: "Light", selection: $light)
                }
                .background(Theme.field, in: RoundedRectangle(cornerRadius: 12))
 
                // Watering Days + Water
                VStack(spacing: 0) {
                    PickerRow(icon: "drop", title: "Watering Days", selection: $days)
                    Divider().overlay(Color(white: 0.3)).padding(.leading, 14)
                    PickerRow(icon: "drop", title: "Water", selection: $water)
                }
                .background(Theme.field, in: RoundedRectangle(cornerRadius: 12))
 
                // Delete (يظهر في وضع التعديل فقط)
                if let existing {
                    Button {
                        store.delete(existing)
                        dismiss()
                    } label: {
                        Text("Delete Reminder")
                            .font(.subheadline)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Theme.field, in: RoundedRectangle(cornerRadius: 12))
                    }
                }
 
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .presentationDragIndicator(.visible)
        .onAppear { if existing == nil { nameFocused = true } }
    }
 
    // MARK: Custom navigation bar (X  —  Set Reminder  —  ✓)
 
    private var navBar: some View {
        ZStack {
            Text("Set Reminder")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
 
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 32, height: 32)
                        .background(Color(white: 0.3), in: Circle())
                }
                Spacer()
                Button(action: save) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 32, height: 32)
                        .background(Theme.button.opacity(canSave ? 1 : 0.4), in: Circle())
                }
                .disabled(!canSave)
            }
        }
    }
 
    private func save() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
 
        if var plant = existing {
            plant.name = trimmed
            plant.room = room
            plant.light = light
            plant.wateringDays = days
            plant.water = water
            store.update(plant)
        } else {
            store.add(Plant(name: trimmed, room: room, light: light,
                            wateringDays: days, water: water))
        }
        onSave()
        dismiss()
    }
}
