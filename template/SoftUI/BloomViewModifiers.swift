import SwiftUI

struct BloomScreenModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    BloomPalette.background.ignoresSafeArea()
                    RadialGradient(
                        colors: [BloomPalette.accent.opacity(0.18), .clear],
                        center: .topTrailing,
                        startRadius: 40,
                        endRadius: 420
                    )
                    .ignoresSafeArea()
                }
            )
            .foregroundStyle(BloomPalette.text)
    }
}

struct BloomSerifTitle: ViewModifier {
    let size: CGFloat

    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: .semibold, design: .serif))
            .foregroundStyle(BloomPalette.text)
    }
}

extension View {
    func bloomScreen() -> some View { modifier(BloomScreenModifier()) }

    func bloomSerifTitle(_ size: CGFloat = 28) -> some View {
        modifier(BloomSerifTitle(size: size))
    }
}
