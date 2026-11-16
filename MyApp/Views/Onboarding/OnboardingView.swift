import SwiftUI

struct OnboardingView: View {
    let onStart: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Header()
            Spacer()
            Mascot(size: 190)
            Text("Start your plant journey!")
                .font(.headline)
                .foregroundStyle(Theme.primaryText)
                .padding(.top, 24)
            Text("Now all your plants will be in one place and\nwe will help you take care of them :) 🪴")
                .font(.caption2)
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.secondaryText)
                .padding(.top, 8)
            Spacer()
            Button(action: onStart) {
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
