import SwiftUI

struct ConceptGlyph: View {
    let concept: Concept
    var size: CGFloat = 22
    var body: some View {
        Image(systemName: concept.symbol)
            .font(.system(size: size, weight: .semibold))
            .rotationEffect(.degrees(concept.rotation))
            .foregroundStyle(concept.category == .icon ? Theme.text : Theme.blue)
            .frame(width: size * 2.2, height: size * 2.2)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: size * 0.6, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

struct ConceptCard: View {
    let concept: Concept
    let seen: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Theme.fill)
                .frame(height: 86)
                .overlay { ConceptGlyph(concept: concept) }
                .overlay(alignment: .topTrailing) {
                    if seen {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(Theme.blue)
                            .padding(8)
                    }
                }
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 5) {
                    Text(String(format: "%02d", Library.number(of: concept)))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Theme.blue)
                        .monospacedDigit()
                    Text(concept.ko)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Theme.text)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
                Text(concept.en)
                    .font(.system(size: 12.5))
                    .foregroundStyle(Theme.sub)
                    .lineLimit(1)
            }
            .padding(.horizontal, 4)
        }
        .padding(10)
        .padding(.bottom, 4)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

struct HomeView: View {
    @EnvironmentObject private var progress: ProgressStore
    @State private var query = ""
    @State private var selected: ConceptCategory? = nil
    @State private var confirmReset = false

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    private var visibleCategories: [ConceptCategory] {
        if let selected { return [selected] }
        return ConceptCategory.allCases
    }

    private func items(_ category: ConceptCategory) -> [Concept] {
        let list = Library.concepts(in: category)
        let q = query.trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return list }
        return list.filter {
            $0.ko.localizedCaseInsensitiveContains(q) || $0.en.localizedCaseInsensitiveContains(q) || $0.summary.contains(q)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    progressCard
                    searchField
                    categoryChips
                    ForEach(visibleCategories) { cat in
                        let list = items(cat)
                        if !list.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(alignment: .firstTextBaseline) {
                                    Text(cat.title).font(.system(size: 20, weight: .bold)).foregroundStyle(Theme.text)
                                    Text("\(list.count)").font(.system(size: 16, weight: .bold)).foregroundStyle(Theme.blue)
                                    Spacer()
                                }
                                Text(cat.subtitle).font(.system(size: 14)).foregroundStyle(Theme.sub).padding(.top, -8)
                                LazyVGrid(columns: columns, spacing: 12) {
                                    ForEach(list) { c in
                                        NavigationLink(value: c) {
                                            ConceptCard(concept: c, seen: progress.seen.contains(c.id))
                                        }
                                        .buttonStyle(PressStyle())
                                    }
                                }
                            }
                        }
                    }
                    if visibleCategories.allSatisfy({ items($0).isEmpty }) {
                        VStack(spacing: 10) {
                            Image(systemName: "magnifyingglass").font(.system(size: 32)).foregroundStyle(Theme.faint)
                            Text("‘\(query)’에 맞는 개념이 없어요").font(.system(size: 15)).foregroundStyle(Theme.sub)
                        }
                        .frame(maxWidth: .infinity).padding(.vertical, 40)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Theme.bg.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: Concept.self) { ConceptDetailView(concept: $0) }
            .navigationDestination(for: ConceptPair.self) { CompareView(pair: $0) }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 14) {
            Pill(text: "헷갈리는 UI \(Library.concepts.count)가지")
            VStack(alignment: .leading, spacing: 2) {
                Text("눌러보면").foregroundStyle(Theme.text)
                Text("바로 알아요").foregroundStyle(Theme.blue)
            }
            .font(.system(size: 34, weight: .heavy))
            Text("이름만 들으면 헷갈리는 UI들,\n실제로 만져보면서 차이를 익혀요.")
                .font(.system(size: 15)).foregroundStyle(Theme.sub)
        }
        .padding(.top, 16)
    }

    private var progressCard: some View {
        let total = Library.concepts.count
        let seen = progress.seen.count
        return HStack(spacing: 14) {
            ZStack {
                Circle().stroke(Theme.fill, lineWidth: 6)
                Circle().trim(from: 0, to: total == 0 ? 0 : CGFloat(seen) / CGFloat(total))
                    .stroke(Theme.blue, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text("\(total == 0 ? 0 : seen * 100 / total)%").font(.system(size: 12, weight: .bold)).foregroundStyle(Theme.text)
            }
            .frame(width: 52, height: 52)
            VStack(alignment: .leading, spacing: 3) {
                Text("\(seen)개 눌러봤어요").font(.system(size: 16, weight: .bold)).foregroundStyle(Theme.text)
                Text("전체 \(total)개 중 · 퀴즈 최고 \(progress.bestQuizScore)점").font(.system(size: 13)).foregroundStyle(Theme.sub)
            }
            Spacer()
            if seen > 0 {
                Button { confirmReset = true } label: {
                    Image(systemName: "arrow.counterclockwise").font(.system(size: 14, weight: .semibold)).foregroundStyle(Theme.faint)
                        .frame(width: 32, height: 32)
                }
            }
        }
        .padding(16)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .confirmationDialog("학습 기록을 초기화할까요?", isPresented: $confirmReset, titleVisibility: .visible) {
            Button("초기화", role: .destructive) { progress.reset() }
            Button("취소", role: .cancel) {}
        }
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass").foregroundStyle(Theme.sub)
            TextField("개념 이름으로 찾기 (예: 토스트)", text: $query)
                .submitLabel(.search)
            if !query.isEmpty {
                Button { query = "" } label: { Image(systemName: "xmark.circle.fill").foregroundStyle(Theme.faint) }
            }
        }
        .font(.system(size: 15))
        .padding(.horizontal, 14)
        .frame(height: 48)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chip("전체", symbol: "square.grid.2x2.fill", on: selected == nil) { selected = nil }
                ForEach(ConceptCategory.allCases) { c in
                    chip(c.title, symbol: c.symbol, on: selected == c) { selected = (selected == c) ? nil : c }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, -20)
    }

    private func chip(_ title: String, symbol: String, on: Bool, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation(.spring(duration: 0.3)) { action() }
            Haptic.selection()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: symbol).font(.system(size: 12, weight: .semibold))
                Text(title).font(.system(size: 14, weight: .semibold))
            }
            .foregroundStyle(on ? Color.white : Theme.text)
            .padding(.horizontal, 14)
            .frame(height: 38)
            .background(on ? Theme.blue : Theme.card, in: Capsule())
        }
        .buttonStyle(PressStyle())
    }
}
