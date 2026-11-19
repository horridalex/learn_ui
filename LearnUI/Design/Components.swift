import SwiftUI

// MARK: - Phone frame (모든 데모가 같은 틀 안에서 동작)

struct PhoneFrame<Content: View>: View {
    var height: CGFloat = 480
    var dark = false
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            StatusBar(dark: dark)
            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 280, height: height)
        .background(dark ? Color(hex: 0x15171C) : Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 38, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 38, style: .continuous)
                .strokeBorder(Theme.fillStrong, lineWidth: 5)
        }
        .shadow(color: .black.opacity(0.07), radius: 18, y: 8)
    }
}

struct StatusBar: View {
    var dark = false
    var body: some View {
        HStack(spacing: 4) {
            Text("9:41").font(.system(size: 12, weight: .semibold))
            Spacer()
            Image(systemName: "cellularbars")
            Image(systemName: "wifi")
            Image(systemName: "battery.75percent")
        }
        .font(.system(size: 11, weight: .semibold))
        .foregroundStyle(dark ? Color.white : Theme.text)
        .padding(.horizontal, 26)
        .frame(height: 34)
    }
}

// MARK: - Mock building blocks

struct ScreenTitle: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 21, weight: .bold))
            .foregroundStyle(Theme.text)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct MockRow: View {
    var index: Int = 0
    var title: String
    var subtitle: String = ""
    var symbol: String? = nil

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Theme.pastel(index))
                .frame(width: 42, height: 42)
                .overlay {
                    if let symbol {
                        Image(systemName: symbol)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(Theme.deep(index))
                    }
                }
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Theme.text)
                    .lineLimit(1)
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.sub)
                        .lineLimit(1)
                }
            }
            Spacer(minLength: 0)
        }
    }
}

struct SkeletonBar: View {
    var width: CGFloat? = nil
    var height: CGFloat = 10
    var color: Color = Theme.fill
    var body: some View {
        RoundedRectangle(cornerRadius: height / 2, style: .continuous)
            .fill(color)
            .frame(width: width, height: height)
    }
}

/// 딤/블러 데모에서 쓰는 알록달록한 배경 콘텐츠
struct ColorfulContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ScreenTitle(text: "오늘의 추천")
            ForEach(0..<6, id: \.self) { i in
                HStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 10).fill(Theme.deep(i).opacity(0.85)).frame(width: 38, height: 38)
                    VStack(alignment: .leading, spacing: 5) {
                        SkeletonBar(width: CGFloat(110 + (i * 23) % 60), height: 9, color: Theme.deep(i).opacity(0.45))
                        SkeletonBar(width: CGFloat(70 + (i * 31) % 50), height: 7, color: Theme.deep(i).opacity(0.25))
                    }
                    Spacer()
                }
                .padding(8)
                .background(Theme.pastel(i), in: RoundedRectangle(cornerRadius: 14))
            }
            Spacer(minLength: 0)
        }
        .padding(16)
    }
}

// MARK: - Small pieces

struct Pill: View {
    let text: String
    var color: Color = Theme.blue
    var soft: Color = Theme.blueSoft
    var body: some View {
        Text(text)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(soft, in: Capsule())
    }
}

struct CountBadge: View {
    let count: Int
    var body: some View {
        Text(count > 99 ? "99+" : "\(count)")
            .font(.system(size: 11, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 5)
            .frame(minWidth: 19, minHeight: 19)
            .background(Theme.red, in: Capsule())
            .overlay(Capsule().strokeBorder(Theme.card, lineWidth: 2))
            .contentTransition(.numericText())
    }
}

struct RedDot: View {
    var size: CGFloat = 8
    var body: some View {
        Circle().fill(Theme.red).frame(width: size, height: size)
            .overlay(Circle().strokeBorder(Theme.card, lineWidth: 1.5))
    }
}

struct ToastPill: View {
    let text: String
    var icon: String? = nil
    var body: some View {
        HStack(spacing: 8) {
            if let icon {
                Image(systemName: icon).foregroundStyle(Theme.green)
            }
            Text(text)
        }
        .font(.system(size: 14, weight: .semibold))
        .foregroundStyle(.white)
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(Theme.toast, in: Capsule())
        .shadow(color: .black.opacity(0.15), radius: 10, y: 4)
    }
}

/// 데모 아래에 상황 설명을 보여주는 말풍선
struct DemoNote: View {
    let text: String
    var icon: String = "lightbulb.fill"
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Theme.blue)
                .padding(.top, 1)
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Theme.text)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.blueSoft, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .animation(.easeInOut(duration: 0.2), value: text)
    }
}

struct NativeButton: View {
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Label(title, systemImage: "iphone.gen3")
        }
        .buttonStyle(DSButtonStyle(kind: .secondary))
    }
}

struct IconTile: View {
    let symbol: String
    var rotation: Double = 0
    var size: CGFloat = 20
    var tint: Color = Theme.text
    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: size, weight: .semibold))
            .rotationEffect(.degrees(rotation))
            .foregroundStyle(tint)
            .frame(width: 40, height: 40)
            .contentShape(Rectangle())
    }
}

struct Triangle: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: r.minX, y: r.minY))
        p.addLine(to: CGPoint(x: r.maxX, y: r.minY))
        p.addLine(to: CGPoint(x: r.midX, y: r.maxY))
        p.closeSubpath()
        return p
    }
}

struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: 9 * sin(animatableData * .pi * 4), y: 0))
    }
}

struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = -0.7
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geo in
                    LinearGradient(colors: [.clear, .white.opacity(0.55), .clear], startPoint: .leading, endPoint: .trailing)
                        .frame(width: geo.size.width * 0.6)
                        .offset(x: phase * geo.size.width)
                }
                .mask(content)
                .allowsHitTesting(false)
            }
            .onAppear {
                withAnimation(.linear(duration: 1.3).repeatForever(autoreverses: false)) { phase = 1.1 }
            }
    }
}

extension View {
    func shimmer() -> some View { modifier(Shimmer()) }
}

/// 체크박스 / 라디오 공용 마크
struct CheckMark: View {
    let on: Bool
    var round = false
    var body: some View {
        ZStack {
            if round {
                Circle().strokeBorder(on ? Theme.blue : Theme.fillStrong, lineWidth: 2)
                if on { Circle().fill(Theme.blue).padding(5) }
            } else {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(on ? Theme.blue : Color.clear)
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .strokeBorder(on ? Theme.blue : Theme.fillStrong, lineWidth: 2)
                if on {
                    Image(systemName: "checkmark").font(.system(size: 12, weight: .heavy)).foregroundStyle(.white)
                }
            }
        }
        .frame(width: 22, height: 22)
        .animation(.spring(duration: 0.25), value: on)
    }
}

/// 둥근 입력 필드 박스
struct FieldBox<Content: View>: View {
    var focused = false
    var error = false
    @ViewBuilder var content: () -> Content
    var body: some View {
        content()
            .font(.system(size: 15))
            .padding(.horizontal, 14)
            .frame(height: 48)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(error ? Theme.red : (focused ? Theme.blue : Theme.fillStrong), lineWidth: (focused || error) ? 2 : 1)
            }
            .animation(.easeInOut(duration: 0.15), value: focused)
            .animation(.easeInOut(duration: 0.15), value: error)
    }
}

/// 안쪽 하단에 붙는 시트 모양
struct SheetShape: Shape {
    var radius: CGFloat = 22
    func path(in rect: CGRect) -> Path {
        UnevenRoundedRectangle(topLeadingRadius: radius, topTrailingRadius: radius, style: .continuous).path(in: rect)
    }
}

struct Grabber: View {
    var body: some View {
        Capsule().fill(Theme.fillStrong).frame(width: 36, height: 5)
    }
}
