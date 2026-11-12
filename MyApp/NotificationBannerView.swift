//
//  NotificationBannerView.swift
//  MyApp
//
//  Created by Dhay Bandar on 01/06/1448 AH.
//

import SwiftUI

// MARK: - In-App Notification Banner View

struct NotificationBannerView: View {
    let banner: InAppBanner
    let onDismiss: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 17))
                .foregroundStyle(Theme.accent)
                .frame(width: 36, height: 36)
                .background(Color(white: 0.18), in: RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(banner.title)
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                    Spacer()
                    Text("now")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Text(banner.body)
                    .font(.caption2)
                    .foregroundStyle(Color(white: 0.85))
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(white: 0.12).opacity(0.95))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.5), radius: 10, y: 6)
        .onTapGesture { onDismiss() }
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        NotificationBannerView(
            banner: InAppBanner(title: "My Plants 🌱", body: "Time to water Pothos 💧 (20-50 ml)"),
            onDismiss: {}
        )
        .padding()
    }
    .preferredColorScheme(.dark)
}
