//
//  Components.swift
//  MyApp
//

import SwiftUI

enum Theme {
    static let background = Color(uiColor: .systemBackground)
    static let sheet = Color(uiColor: .systemBackground)
    static let field = Color(uiColor: .secondarySystemBackground)
    static let primaryText = Color.primary
    static let secondaryText = Color.secondary
    static let separator = Color(uiColor: .separator)
    static let accent = Color(red: 0.30, green: 0.85, blue: 0.62)
    static let button = Color(red: 0.24, green: 0.48, blue: 0.40)
}

struct Mascot: View {
    var size: CGFloat = 170

    var body: some View {
        Image("plantMascot")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
}

struct PlantProgressBar: View {
    let progress: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule().fill(Theme.separator.opacity(0.45))
                Capsule()
                    .fill(Theme.accent)
                    .frame(width: geometry.size.width * progress)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: progress)
            }
        }
        .frame(height: 4)
    }
}

struct Chip: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.caption2)
        .foregroundStyle(Theme.accent)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Theme.accent.opacity(0.15), in: RoundedRectangle(cornerRadius: 6))
    }
}

struct PickerRow<T: Hashable & CaseIterable & RawRepresentable>: View where T.RawValue == String {
    let icon: String
    let title: String
    @Binding var selection: T

    var body: some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.subheadline)
                .foregroundStyle(Theme.primaryText)
            Spacer()
            Menu {
                Picker("", selection: $selection) {
                    ForEach(Array(T.allCases), id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(selection.rawValue)
                    Image(systemName: "chevron.up.chevron.down").font(.caption2)
                }
                .font(.subheadline)
                .foregroundStyle(Theme.secondaryText)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
}
