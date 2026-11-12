//
//  AllDoneView.swift
//  MyApp
//
//  Created by Dhay Bandar on 01/06/1448 AH.
//

import SwiftUI

// MARK: - All Done View

struct AllDoneView: View {
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Mascot(size: 170)
            Text("All Done! 🎉")
                .font(.headline)
                .foregroundStyle(.white)
            Text("All Reminders Completed")
                .font(.caption2)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .transition(.opacity)
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        AllDoneView()
    }
    .preferredColorScheme(.dark)
}
