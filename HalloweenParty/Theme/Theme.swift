import SwiftUI

/// Palette taken from the deck (near-black background, off-white text,
/// orange accent, grey subtitle) plus a Halloween purple.
enum Theme {
    static let background = Color(hex: 0x0E1014)
    static let surface = Color(hex: 0x1A1D24)
    static let text = Color(hex: 0xF2F4F6)
    static let secondaryText = Color(hex: 0x9AA3AE)
    static let pumpkin = Color(hex: 0xE25B2A)
    static let purple = Color(hex: 0x7B3FBF)

    static let heroGradient = LinearGradient(
        colors: [purple.opacity(0.55), background, pumpkin.opacity(0.35)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let brandCredit = "Tanner Hughes · TJH Ventures LLC"
}

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}
