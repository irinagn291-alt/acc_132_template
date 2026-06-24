import SwiftUI

struct PetalPluckAnimation: View {
    let index: Int
    let total: Int
    let isPlucked: Bool
    let reduceMotion: Bool

    private var angle: Double { (Double(index) / Double(max(total, 1))) * 360 }

    var body: some View {
        ZStack {
            PetalShape()
                .fill(
                    LinearGradient(
                        colors: isPlucked
                            ? [BloomPalette.surface.opacity(0.25), BloomPalette.surface.opacity(0.1)]
                            : [BloomPalette.accent, BloomPalette.primary],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 34, height: 58)
                .rotationEffect(.degrees(angle))
                .offset(y: -42)
                .opacity(isPlucked ? 0.2 : 1)
                .scaleEffect(isPlucked ? 0.6 : 1)
                .offset(
                    x: isPlucked ? CGFloat(cos(angle * .pi / 180)) * 28 : 0,
                    y: isPlucked ? CGFloat(sin(angle * .pi / 180)) * 28 + 18 : 0
                )
                .animation(reduceMotion ? nil : .spring(response: 0.45, dampingFraction: 0.72), value: isPlucked)
        }
    }
}

struct PetalShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY),
            control: CGPoint(x: rect.maxX, y: rect.midY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.midY)
        )
        return path
    }
}

struct FlowerHeroView: View {
    let totalPetals: Int
    let pluckedCount: Int
    let reduceMotion: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(BloomPalette.heroGradient)
                .frame(width: 180, height: 180)
                .shadow(color: BloomPalette.primary.opacity(0.25), radius: 20, y: 10)

            ForEach(0..<totalPetals, id: \.self) { idx in
                PetalPluckAnimation(
                    index: idx,
                    total: totalPetals,
                    isPlucked: idx < pluckedCount,
                    reduceMotion: reduceMotion
                )
            }

            Circle()
                .fill(BloomPalette.secondary.opacity(0.85))
                .frame(width: 52, height: 52)
            Image(systemName: "sparkle")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.white)
        }
        .frame(height: 200)
    }
}
