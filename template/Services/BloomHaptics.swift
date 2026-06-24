import UIKit

enum BloomHaptics {
    static let shared = BloomHapticsEngine()
}

final class BloomHapticsEngine {
    private var enabled = true

    func setEnabled(_ value: Bool) { enabled = value }

    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard enabled else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    func selection() {
        guard enabled else { return }
        UISelectionFeedbackGenerator().selectionChanged()
    }

    func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard enabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
}
