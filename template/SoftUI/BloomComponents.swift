import SwiftUI

struct BloomPrimaryButton: View {
    let title: String
    var icon: String? = nil
    var isLoading = false
    var isDisabled = false
    let action: () -> Void

    init(
        _ title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button {
            BloomHaptics.shared.impact(.light)
            action()
        } label: {
            HStack(spacing: 10) {
                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    if let icon {
                        Image(systemName: icon).font(.system(size: 16, weight: .semibold))
                    }
                    Text(title).font(.system(size: 17, weight: .semibold, design: .rounded))
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 54)
            .background(
                LinearGradient(
                    colors: [BloomPalette.primary, BloomPalette.secondary],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
            .shadow(color: BloomPalette.primary.opacity(0.3), radius: 10, y: 5)
            .opacity(isDisabled ? 0.5 : 1)
        }
        .disabled(isDisabled || isLoading)
    }
}

struct BloomSectionHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).bloomSerifTitle(22)
            if let subtitle {
                Text(subtitle).font(.subheadline).foregroundStyle(BloomPalette.textMuted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct BloomEmptyState: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 44))
                .foregroundStyle(BloomPalette.secondary)
            Text(title).bloomSerifTitle(20)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(BloomPalette.textMuted)
                .multilineTextAlignment(.center)
        }
        .padding(24)
    }
}
