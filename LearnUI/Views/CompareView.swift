import SwiftUI

struct CompareListView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    VStack(alignment: .leading, spacing: 14) {
                        Pill(text: "헷갈리는 짝 \(Library.pairs.count)쌍")
                        VStack(alignment: .leading, spacing: 2) {
                            Text("닮았는데").foregroundStyle(Theme.text)
                            Text("뜻은 달라요").foregroundStyle(Theme.blue)
                        }
                        .font(.system(size: 34, weight: .heavy))
                        Text("두 개를 번갈아 눌러보면서\n차이를 한눈에 비교해요.")
                            .font(.system(size: 15)).foregroundStyle(Theme.sub)
                    }
                    .padding(.top, 16)

                    ForEach(ConceptCategory.allCases) { cat in
                        let list = Library.pairs.filter { Library.concept($0.a)?.category == cat }
                        if !list.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text(cat.title).font(.system(size: 20, weight: .bold)).foregroundStyle(Theme.text)
                                ForEach(Array(list.enumerated()), id: \.element.id) { idx, pair in
                                    NavigationLink(value: pair) {
                                        PairCard(pair: pair, number: idx + 1)
                                    }
                                    .buttonStyle(PressStyle())
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .background(Theme.bg.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: ConceptPair.self) { CompareView(pair: $0) }
            .navigationDestination(for: Concept.self) { ConceptDetailView(concept: $0) }
        }
    }
}

struct PairCard: View {
    let pair: ConceptPair
    let number: Int

    var body: some View {
        if let a = Library.concept(pair.a), let b = Library.concept(pair.b) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    ConceptGlyph(concept: a, size: 16)
                    Text("vs").font(.system(size: 13, weight: .semibold)).foregroundStyle(Theme.faint)
                    ConceptGlyph(concept: b, size: 16)
                    Spacer()
                    Image(systemName: "chevron.right").font(.system(size: 13, weight: .bold)).foregroundStyle(Theme.faint)
                }
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(String(format: "%02d", number)).font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.blue).monospacedDigit()
                    Text(a.ko).font(.system(size: 17, weight: .bold)).foregroundStyle(Theme.text)
                    Text("vs").font(.system(size: 13)).foregroundStyle(Theme.faint)
                    Text(b.ko).font(.system(size: 17, weight: .bold)).foregroundStyle(Theme.text)
                }
                Text(pair.headline)
                    .font(.system(size: 14)).foregroundStyle(Theme.sub)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
    }
}

struct CompareView: View {
    let pair: ConceptPair
    @State private var side = 0
    @EnvironmentObject private var progress: ProgressStore

    var body: some View {
        if let a = Library.concept(pair.a), let b = Library.concept(pair.b) {
            let current = side == 0 ? a : b
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 10) {
                        Pill(text: "헷갈리는 짝")
                        Text(pair.headline)
                            .font(.system(size: 26, weight: .heavy))
                            .foregroundStyle(Theme.text)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 4)

                    HStack(spacing: 10) {
                        sideButton(a, index: 0)
                        Text("vs").font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.faint)
                        sideButton(b, index: 1)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Label("\(current.ko) 눌러보기", systemImage: "hand.tap.fill")
                                .font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.blue)
                            Spacer()
                            Button {
                                withAnimation(.spring(duration: 0.35)) { side = 1 - side }
                            } label: {
                                Label("\(side == 0 ? b.ko : a.ko)(으)로", systemImage: "arrow.left.arrow.right")
                                    .font(.system(size: 13, weight: .semibold))
                            }
                            .buttonStyle(DSButtonStyle(kind: .secondary, compact: true))
                        }
                        Text(current.summary)
                            .font(.system(size: 15, weight: .medium)).foregroundStyle(Theme.text)
                            .fixedSize(horizontal: false, vertical: true)
                        DemoView(id: current.id)
                            .id(current.id)
                            .transition(.opacity)
                    }
                    .cardStyle()

                    SectionCard(title: "차이 정리", symbol: "list.bullet.rectangle.fill") {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(Array(pair.points.enumerated()), id: \.offset) { idx, p in
                                HStack(alignment: .top, spacing: 12) {
                                    Text("\(idx + 1)")
                                        .font(.system(size: 13, weight: .bold)).foregroundStyle(Theme.blue)
                                        .frame(width: 24, height: 24)
                                        .background(Theme.blueSoft, in: Circle())
                                    Text(p).font(.system(size: 15)).foregroundStyle(Theme.text)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(.top, 2)
                                }
                            }
                        }
                    }

                    HStack(spacing: 10) {
                        NavigationLink(value: a) { detailLink(a) }.buttonStyle(PressStyle())
                        NavigationLink(value: b) { detailLink(b) }.buttonStyle(PressStyle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .background(Theme.bg.ignoresSafeArea())
            .navigationTitle("\(a.ko) vs \(b.ko)")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                progress.markSeen(a.id)
            }
            .onChange(of: side) { _, newValue in
                progress.markSeen(newValue == 0 ? a.id : b.id)
            }
        }
    }

    private func sideButton(_ c: Concept, index: Int) -> some View {
        Button {
            withAnimation(.spring(duration: 0.35)) { side = index }
            Haptic.selection()
        } label: {
            VStack(spacing: 8) {
                ConceptGlyph(concept: c, size: 18)
                Text(c.ko).font(.system(size: 16, weight: .bold))
                Text(c.en).font(.system(size: 11)).lineLimit(1).minimumScaleFactor(0.7)
                    .foregroundStyle(side == index ? Theme.blue : Theme.sub)
            }
            .foregroundStyle(side == index ? Theme.blue : Theme.text)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(side == index ? Theme.blue : Color.clear, lineWidth: 2.5)
            }
        }
        .buttonStyle(PressStyle())
    }

    private func detailLink(_ c: Concept) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("자세히 보기").font(.system(size: 12)).foregroundStyle(Theme.sub)
                Text(c.ko).font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Theme.faint)
        }
        .padding(16)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
