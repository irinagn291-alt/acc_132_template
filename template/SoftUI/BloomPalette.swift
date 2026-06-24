import SwiftUI

enum BloomPalette {
    static let primary = Color(hex: 0xE8998D)
    static let secondary = Color(hex: 0xB5838D)
    static let accent = Color(hex: 0xFFB4A2)
    static let background = Color(hex: 0xFFF0F3)
    static let surface = Color(hex: 0xFFCCD5)
    static let text = Color(hex: 0x590D22)
    static let textMuted = Color(hex: 0x590D22).opacity(0.62)
    static let success = Color(hex: 0x7CB69D)
    static let warning = Color(hex: 0xE8B86D)
    static let danger = Color(hex: 0xC9184A)

    static var heroGradient: LinearGradient {
        LinearGradient(
            colors: [primary.opacity(0.85), accent.opacity(0.7), surface.opacity(0.5)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var cardGradient: LinearGradient {
        LinearGradient(
            colors: [Color.white.opacity(0.55), surface.opacity(0.35)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}
