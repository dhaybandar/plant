//
//  PlantRow.swift
//  Planto
//

import SwiftUI

struct PlantRow: View {
    let plant: Plant
    let onToggle: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Button(action: onToggle) {
                Image(systemName: plant.isDoneToday ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(plant.isDoneToday ? Theme.accent : Theme.secondaryText)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(plant.isDoneToday ? "Mark as not watered" : "Mark as watered")

            VStack(alignment: .leading, spacing: 6) {
                Label("in \(plant.room.rawValue)", systemImage: "location")
                    .font(.system(size: 10))
                    .foregroundStyle(Theme.secondaryText)
                Text(plant.name)
                    .font(.title3)
                    .foregroundStyle(plant.isDoneToday ? Theme.secondaryText : Theme.primaryText)
                HStack(spacing: 8) {
                    Chip(
                        icon: plant.light.icon,
                        text: plant.light.rawValue,
                        foregroundColor: plant.isDoneToday ? Theme.sunTag.opacity(0.65) : Theme.sunTag
                    )
                    Chip(
                        icon: "drop",
                        text: plant.water.rawValue,
                        foregroundColor: plant.isDoneToday ? Theme.waterTag.opacity(0.65) : Theme.waterTag
                    )
                }
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
