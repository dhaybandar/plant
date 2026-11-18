import SwiftUI

struct NotificationBannerView: View {
    let banner: InAppBanner
    let onDismiss: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 17))
                .foregroundStyle(Theme.accent)
                .frame(width: 36, height: 36)
                .background(Theme.field, in: RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(banner.title)
                        .font(.caption.bold())
                        .foregroundStyle(Theme.primaryText)
                    Spacer()
                    Text("now")
                        .font(.caption2)
                        .foregroundStyle(Theme.secondaryText)
                }

                Text(banner.body)
                    .font(.caption2)
                    .foregroundStyle(Theme.secondaryText)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.field)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.separator.opacity(0.7), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 10, y: 6)
        .onTapGesture(perform: onDismiss)//يلتقط نقره اليوزر ويستدعي اجراء الاغلاق
    }
}
