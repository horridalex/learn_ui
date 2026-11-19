import SwiftUI

struct SectionCard<Content: View>: View {
    let title: String
    let symbol: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(title, systemImage: symbol)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Theme.blue)
            content()
        }
        .cardStyle()
    }
}

struct ConceptDetailView: View {
    let concept: Concept
    @EnvironmentObject private var progress: ProgressStore

    private var neighbors: (Concept?, Concept?) {
        let list = Library.concepts
        guard let idx = list.firstIndex(of: concept) else { return (nil, nil) }
        return (idx > 0 ? list[idx - 1] : nil, idx < list.count - 1 ? list[idx + 1] : nil)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header

                // 직접 눌러보기
                VStack(alignment: .leading, spacing: 14) {
                    Label("직접 눌러보기", systemImage: "hand.tap.fill")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Theme.blue)
                    Text(concept.hint)
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.sub)
                        .fixedSize(horizontal: false, vertical: true)
                    DemoView(id: concept.id)
                        .padding(.top, 4)
                }
                .cardStyle()

                SectionCard(title: "어떤 UI인가요?", symbol: "text.book.closed.fill") {
                    Text(concept.detail)
                        .font(.system(size: 16))
                        .foregroundStyle(Theme.text)
                        .lineSpacing(5)
                        .fixedSize(horizontal: false, vertical: true)
                }

                SectionCard(title: "이럴 때 써요", symbol: "checkmark.seal.fill") {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(concept.whenToUse, id: \.self) { item in
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "checkmark").font(.system(size: 13, weight: .bold)).foregroundStyle(Theme.green).padding(.top, 3)
                                Text(item).font(.system(size: 15)).foregroundStyle(Theme.text)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }

                SectionCard(title: "핵심 포인트", symbol: "star.fill") {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(concept.points.enumerated()), id: \.offset) { idx, point in
                            HStack(alignment: .top, spacing: 12) {
                                Text("\(idx + 1)")
                                    .font(.system(size: 13, weight: .bold)).foregroundStyle(Theme.blue)
                                    .frame(width: 24, height: 24)
                                    .background(Theme.blueSoft, in: Circle())
                                Text(point).font(.system(size: 15)).foregroundStyle(Theme.text)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.top, 2)
                            }
                        }
                    }
                }

                let pairs = Library.pairs(for: concept.id)
                if !pairs.isEmpty {
                    SectionCard(title: "헷갈리는 짝", symbol: "arrow.left.arrow.right") {
                        VStack(spacing: 10) {
                            ForEach(pairs) { pair in
                                if let other = Library.partner(of: concept.id, in: pair) {
                                    NavigationLink(value: pair) {
                                        PairRow(pair: pair, focus: concept, other: other)
                                    }
                                    .buttonStyle(PressStyle())
                                }
                            }
                        }
                    }
                }

                navigationFooter
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(Theme.bg.ignoresSafeArea())
        .navigationTitle(concept.ko)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { progress.markSeen(concept.id) }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Pill(text: concept.category.title)
                Text(String(format: "%02d", Library.number(of: concept)))
                    .font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.faint)
            }
            HStack(alignment: .center, spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(concept.ko).font(.system(size: 32, weight: .heavy)).foregroundStyle(Theme.text)
                    Text(concept.en).font(.system(size: 16, weight: .medium)).foregroundStyle(Theme.sub)
                }
                Spacer()
                ConceptGlyph(concept: concept, size: 24)
            }
            Text(concept.summary)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Theme.text)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)
        }
        .padding(.horizontal, 4)
        .padding(.top, 4)
    }

    private var navigationFooter: some View {
        let (prev, next) = neighbors
        return HStack(spacing: 10) {
            if let prev {
                NavigationLink(value: prev) {
                    footerLabel("이전", prev.ko, leading: true)
                }
                .buttonStyle(PressStyle())
            }
            if let next {
                NavigationLink(value: next) {
                    footerLabel("다음", next.ko, leading: false)
                }
                .buttonStyle(PressStyle())
            }
        }
        .padding(.top, 4)
    }

    private func footerLabel(_ caption: String, _ title: String, leading: Bool) -> some View {
        HStack {
            if leading { Image(systemName: "chevron.left").foregroundStyle(Theme.faint) }
            VStack(alignment: leading ? .leading : .trailing, spacing: 2) {
                Text(caption).font(.system(size: 12)).foregroundStyle(Theme.sub)
                Text(title).font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text).lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: leading ? .leading : .trailing)
            if !leading { Image(systemName: "chevron.right").foregroundStyle(Theme.faint) }
        }
        .padding(16)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct PairRow: View {
    let pair: ConceptPair
    let focus: Concept
    let other: Concept

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                ConceptGlyph(concept: focus, size: 14)
                Text("vs").font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.faint)
                ConceptGlyph(concept: other, size: 14)
                Text(other.ko).font(.system(size: 16, weight: .bold)).foregroundStyle(Theme.text)
                Spacer()
                Text("비교하기").font(.system(size: 13, weight: .semibold)).foregroundStyle(Theme.blue)
                Image(systemName: "chevron.right").font(.system(size: 12, weight: .bold)).foregroundStyle(Theme.blue)
            }
            Text(pair.headline)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Theme.sub)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.fill, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
