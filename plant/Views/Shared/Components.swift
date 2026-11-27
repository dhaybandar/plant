//
//  Components.swift
//  Planto
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

    // Tag colors from Sketch
    static let sunTag = Color(red: 0.80, green: 0.78, blue: 0.52)
    static let waterTag = Color(red: 0.30, green: 0.65, blue: 0.95)
    static let tagBackground = Color(
        uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.094, green: 0.094, blue: 0.114, alpha: 1.0)
                : UIColor.secondarySystemFill
        }
    )
}

struct Mascot: View {
    var size: CGFloat = 210

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
    var foregroundColor: Color = Theme.accent

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.caption2)
        .foregroundStyle(foregroundColor)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Theme.tagBackground, in: RoundedRectangle(cornerRadius: 8))
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
