//
//  ReminderSheet.swift
//  Planto
//

import SwiftUI

struct ReminderSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: PlantStore

    private let existing: Plant?
    private let onSave: () -> Void

    @State private var name: String
    @State private var room: Room
    @State private var light: Light
    @State private var days: WateringDays
    @State private var water: WaterAmount
    @FocusState private var nameFocused: Bool

    // MARK: - Initialization

    init(plant: Plant?, onSave: @escaping () -> Void = {}) {
        existing = plant
        self.onSave = onSave
        _name = State(initialValue: plant?.name ?? "")
        _room = State(initialValue: plant?.room ?? .bedroom)
        _light = State(initialValue: plant?.light ?? .fullSun)
        _days = State(initialValue: plant?.wateringDays ?? .everyDay)
        _water = State(initialValue: plant?.water ?? .a)
    }

    var body: some View {
        ZStack {
            Theme.sheet.ignoresSafeArea()

            VStack(spacing: 20) {
                navigationBar

                HStack {
                    Text("Plant Name")
                        .font(.subheadline)
                        .foregroundStyle(Theme.primaryText)
                    TextField("Pothos", text: $name)
                        .font(.subheadline)
                        .tint(Theme.accent)
                        .focused($nameFocused)
                        .submitLabel(.done)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(Theme.field, in: RoundedRectangle(cornerRadius: 12))

                VStack(spacing: 0) {
                    PickerRow(icon: "location", title: "Room", selection: $room)
                    Divider().overlay(Theme.separator).padding(.leading, 14)
                    PickerRow(icon: "sun.max", title: "Light", selection: $light)
                }
                .background(Theme.field, in: RoundedRectangle(cornerRadius: 12))

                VStack(spacing: 0) {
                    PickerRow(icon: "drop", title: "Watering Days", selection: $days)
                    Divider().overlay(Theme.separator).padding(.leading, 14)
                    PickerRow(icon: "drop", title: "Water", selection: $water)
                }
                .background(Theme.field, in: RoundedRectangle(cornerRadius: 12))

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
        .onAppear {
            // Automatically focus the text field when adding a new plant
            if existing == nil {
                nameFocused = true
            }
        }
    }

    // MARK: - Subviews

    private var navigationBar: some View {
        ZStack {
            Text("Set Reminder")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.primaryText)

            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Theme.primaryText)
                        .frame(width: 32, height: 32)
                        .background(Theme.separator.opacity(0.45), in: Circle())
                }
                Spacer()
                Button(action: save) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 32, height: 32)
                        .background(Theme.button, in: Circle())
                }
            }
        }
    }

    // MARK: - Actions

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        // Fall back to default name "Planto" if field is left empty
        let finalName = trimmedName.isEmpty ? "Planto" : trimmedName

        if var plant = existing {
            plant.name = finalName
            plant.room = room
            plant.light = light
            plant.wateringDays = days
            plant.water = water
            store.update(plant)
        } else {
            store.add(
                Plant(
                    name: finalName,
                    room: room,
                    light: light,
                    wateringDays: days,
                    water: water
                )
            )
        }

        dismiss()
        onSave()
    }
}
