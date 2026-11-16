import SwiftUI

struct Header: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("My Plants \(Image(systemName: "leaf.fill"))")
                    .font(.title2.bold())
                    .foregroundStyle(Theme.primaryText)
                Spacer()
            }
            .padding(.horizontal, 20)

            Divider()
                .overlay(Theme.separator)
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}
