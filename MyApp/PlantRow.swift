//
//  PlantRow.swift
//  MyApp
//
//  Created by Dhay Bandar on 01/06/1448 AH.
//

import SwiftUI

// MARK: - Plant Row

struct PlantRow: View {
    let plant: Plant
    let onToggle: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Button(action: onToggle) {
                Image(systemName: plant.isDoneToday ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(plant.isDoneToday ? Theme.accent : Color(white: 0.5))
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 6) {
                Label("in \(plant.room.rawValue)", systemImage: "location")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                Text(plant.name)
                    .font(.title3)
                    .foregroundStyle(plant.isDoneToday ? .secondary : Color.white)
                HStack(spacing: 8) {
                    Chip(icon: plant.light.icon, text: plant.light.rawValue)
                    Chip(icon: "drop", text: plant.water.rawValue)
                }
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        PlantRow(
            plant: Plant(name: "Monstera", room: .livingRoom, light: .fullSun, wateringDays: .everyDay, water: .a),
            onToggle: {}
        )
        .padding()
    }
    .preferredColorScheme(.dark)
}
