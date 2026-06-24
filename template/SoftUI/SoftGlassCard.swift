import SwiftUI

struct SoftGlassCard<Content: View>: View {
    var cornerRadius: CGFloat = 22
    private let content: Content

    init(cornerRadius: CGFloat = 22, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(BloomPalette.cardGradient)
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(Color.white.opacity(0.45), lineWidth: 1)
                    )
            }
            .shadow(color: BloomPalette.secondary.opacity(0.12), radius: 14, x: 0, y: 8)
    }
}
