import SwiftUI
import UIKit

// MARK: - Color helpers

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: alpha
        )
    }
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

    static func adaptive(_ light: UInt32, _ dark: UInt32) -> Color {
        Color(uiColor: UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light)
        })
    }
}

// MARK: - Design tokens

enum Theme {
    static let bg = Color.adaptive(0xF2F4F6, 0x0E0F12)
    static let card = Color.adaptive(0xFFFFFF, 0x1B1C20)
    static let fill = Color.adaptive(0xF2F4F6, 0x2A2B31)
    static let fillStrong = Color.adaptive(0xE5E8EB, 0x383A42)
    static let text = Color.adaptive(0x191F28, 0xF2F4F6)
    static let sub = Color.adaptive(0x6B7684, 0x9EA3AD)
    static let faint = Color.adaptive(0xB0B8C1, 0x62666F)
    static let blue = Color(hex: 0x3182F6)
    static let blueSoft = Color.adaptive(0xE8F3FF, 0x1A2B47)
    static let red = Color(hex: 0xF04452)
    static let redSoft = Color.adaptive(0xFFEBEE, 0x3D1D22)
    static let green = Color(hex: 0x15C47E)
    static let greenSoft = Color.adaptive(0xE5F8EF, 0x16352A)
    static let orange = Color(hex: 0xFF9F1A)
    static let toast = Color.adaptive(0x333D4B, 0x4A505B)

    static let pastel: [Color] = [
        Color.adaptive(0xFFE3D3, 0x4A3328),
        Color.adaptive(0xDCEBFF, 0x24344D),
        Color.adaptive(0xD9F2E3, 0x213B2D),
        Color.adaptive(0xFFF1C7, 0x463D22),
        Color.adaptive(0xEADFFF, 0x342B4A),
        Color.adaptive(0xFFDCE3, 0x48272F),
    ]

    static let deep: [Color] = [
        Color(hex: 0xFF8A5B), Color(hex: 0x3182F6), Color(hex: 0x15C47E),
        Color(hex: 0xFFB800), Color(hex: 0x8B5CF6), Color(hex: 0xF04452),
    ]

    static func pastel(_ i: Int) -> Color { pastel[((i % pastel.count) + pastel.count) % pastel.count] }
    static func deep(_ i: Int) -> Color { deep[((i % deep.count) + deep.count) % deep.count] }
}

// MARK: - Buttons

struct DSButtonStyle: ButtonStyle {
    enum Kind { case primary, secondary, danger, ghost, dark }
    var kind: Kind = .primary
    var compact = false
    var fullWidth = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: compact ? 14 : 16, weight: .semibold))
            .foregroundStyle(foreground)
            .lineLimit(1)
            .padding(.horizontal, compact ? 14 : 18)
            .frame(maxWidth: (fullWidth && !compact) ? .infinity : nil)
            .frame(height: compact ? 36 : 50)
            .background(background, in: RoundedRectangle(cornerRadius: compact ? 10 : 14, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.spring(duration: 0.2), value: configuration.isPressed)
    }

    private var foreground: Color {
        switch kind {
        case .primary, .danger, .dark: return .white
        case .secondary: return Theme.blue
        case .ghost: return Theme.sub
        }
    }

    private var background: Color {
        switch kind {
        case .primary: return Theme.blue
        case .secondary: return Theme.blueSoft
        case .danger: return Theme.red
        case .ghost: return Theme.fill
        case .dark: return Theme.toast
        }
    }
}

struct PressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Modifiers

extension View {
    func cardStyle(padding: CGFloat = 20) -> some View {
        self
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

func delay(_ seconds: Double, _ work: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: work)
}

enum Haptic {
    static func tap() { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
    static func success() { UINotificationFeedbackGenerator().notificationOccurred(.success) }
    static func warning() { UINotificationFeedbackGenerator().notificationOccurred(.warning) }
    static func error() { UINotificationFeedbackGenerator().notificationOccurred(.error) }
    static func selection() { UISelectionFeedbackGenerator().selectionChanged() }
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) { UIImpactFeedbackGenerator(style: style).impactOccurred() }
}
