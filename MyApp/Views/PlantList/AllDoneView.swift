import SwiftUI

struct AllDoneView: View {
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Mascot(size: 170)
            Text("All Done! 🎉")
                .font(.headline)
                .foregroundStyle(Theme.primaryText)
            Text("All Reminders Completed")
                .font(.caption2)
                .foregroundStyle(Theme.secondaryText)
            Spacer()
        }
        .transition(.opacity)
    }
}
