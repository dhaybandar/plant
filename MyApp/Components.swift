//
//  Components.swift
//  MyApp
//
//  Created by Dhay Bandar  on 29/05/1448 AH.
//
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
 
// MARK: - Theme
 
enum Theme {
    static let background = Color.black
    static let sheet = Color(white: 0.09)
    static let field = Color(white: 0.17)
    static let accent = Color(red: 0.30, green: 0.85, blue: 0.62)      // أخضر النصوص
    static let button = Color(red: 0.24, green: 0.48, blue: 0.40)      // أخضر الأزرار
}
 
// MARK: - Mascot (ضيف صورة النبتة في Assets باسم "plantMascot")
 
struct Mascot: View {
    var size: CGFloat = 150
 
    private var hasAsset: Bool {
        #if canImport(UIKit)
        return UIImage(named: "plantMascot") != nil
        #else
        return false
        #endif
    }
 
    var body: some View {
        if hasAsset {
            Image("plantMascot")
                .resizable().scaledToFit()
                .frame(width: size, height: size)
        } else {
            Image(systemName: "leaf.fill")
                .resizable().scaledToFit()
                .foregroundStyle(Theme.accent)
                .frame(width: size * 0.6, height: size * 0.6)
                .frame(width: size, height: size)
        }
    }
}
 
// MARK: - Custom animated progress bar
 
struct PlantProgressBar: View {
    let progress: Double
 
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color(white: 0.2))
                Capsule()
                    .fill(Theme.accent)
                    .frame(width: geo.size.width * progress)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: progress)
            }
        }
        .frame(height: 4)
    }
}
 
// MARK: - Chip (Full sun / 20-50 ml)
 
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
 
// MARK: - Picker row (Room / Light / Watering Days / Water)
 
struct PickerRow<T: Hashable & CaseIterable & RawRepresentable>: View
where T.RawValue == String {
    let icon: String
    let title: String
    @Binding var selection: T
 
    var body: some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.subheadline)
                .foregroundStyle(.white)
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
                .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
}
