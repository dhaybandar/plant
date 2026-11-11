//
//  OnboardingView.swift
//  MyApp
//
//  Created by Dhay Bandar on 29/05/1448 AH.
//

import SwiftUI

struct OnboardingView: View {
    let onStart: () -> Void

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Header()
                Spacer()
                Mascot(size: 170)
                Text("Start your plant journey!")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.top, 24)
                Text("Now all your plants will be in one place and\nwe will help you take care of them :) 🪴")
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
                Spacer()
                Button {
                    onStart()
                } label: {
                    Text("Set Plant Reminder")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Theme.button, in: Capsule())
                }
                .padding(.horizontal, 60)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview("Interactive Flow") {
    ContentView()
        .environmentObject(PlantStore(plants: []))
        .preferredColorScheme(.dark)
}

#Preview("Onboarding Screen Only") {
    OnboardingView(onStart: {})
        .preferredColorScheme(.dark)
}
