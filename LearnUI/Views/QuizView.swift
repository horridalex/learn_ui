import SwiftUI

struct QuizQuestion: Identifiable {
    let id = UUID()
    let answer: Concept
    let options: [Concept]
}

enum QuizMaker {
    static func make(count: Int = 10, category: ConceptCategory? = nil) -> [QuizQuestion] {
        let pool = category.map { Library.concepts(in: $0) } ?? Library.concepts
        return pool.shuffled().prefix(count).map { (answer: Concept) -> QuizQuestion in
            var distractors: [Concept] = []
            // 1) 헷갈리는 짝을 먼저 넣어서 난이도 높이기
            for pair in Library.pairs(for: answer.id).shuffled() {
                if let p = Library.partner(of: answer.id, in: pair), !distractors.contains(p) {
                    distractors.append(p)
                }
                if distractors.count >= 2 { break }
            }
            // 2) 같은 카테고리에서 채우기
            for c in Library.concepts(in: answer.category).shuffled() where distractors.count < 3 {
                if c != answer && !distractors.contains(c) { distractors.append(c) }
            }
            // 3) 그래도 부족하면 전체에서
            for c in Library.concepts.shuffled() where distractors.count < 3 {
                if c != answer && !distractors.contains(c) { distractors.append(c) }
            }
            return QuizQuestion(answer: answer, options: (distractors.prefix(3) + [answer]).shuffled())
        }
    }
}

struct QuizView: View {
    @EnvironmentObject private var progress: ProgressStore
    @State private var questions: [QuizQuestion] = []
    @State private var index = 0
    @State private var picked: Concept? = nil
    @State private var score = 0
    @State private var finished = false
    @State private var category: ConceptCategory? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if questions.isEmpty {
                        intro
                    } else if finished {
                        result
                    } else {
                        questionView(questions[index])
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .background(Theme.bg.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: Concept.self) { ConceptDetailView(concept: $0) }
            .navigationDestination(for: ConceptPair.self) { CompareView(pair: $0) }
        }
    }

    // MARK: 시작 화면

    private var intro: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 14) {
                Pill(text: "10문제 퀴즈")
                VStack(alignment: .leading, spacing: 2) {
                    Text("이 상황,").foregroundStyle(Theme.text)
                    Text("무슨 UI일까요?").foregroundStyle(Theme.blue)
                }
                .font(.system(size: 34, weight: .heavy))
                Text("상황 설명을 읽고 알맞은 UI 이름을 골라요.\n헷갈리는 짝이 보기로 함께 나와요.")
                    .font(.system(size: 15)).foregroundStyle(Theme.sub)
            }
            .padding(.top, 16)

            VStack(alignment: .leading, spacing: 10) {
                Text("범위").font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.sub)
                rangeButton(nil, title: "전체", symbol: "square.grid.2x2.fill")
                ForEach(ConceptCategory.allCases) { c in
                    rangeButton(c, title: c.title, symbol: c.symbol)
                }
            }

            Button("퀴즈 시작") { start() }
                .buttonStyle(DSButtonStyle())

            if progress.bestQuizScore > 0 {
                Text("최고 점수 \(progress.bestQuizScore) / 10")
                    .font(.system(size: 14, weight: .semibold)).foregroundStyle(Theme.sub)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private func rangeButton(_ c: ConceptCategory?, title: String, symbol: String) -> some View {
        Button {
            category = c
            Haptic.selection()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: symbol).foregroundStyle(Theme.blue).frame(width: 24)
                Text(title).font(.system(size: 16, weight: .semibold)).foregroundStyle(Theme.text)
                Spacer()
                CheckMark(on: category == c, round: true)
            }
            .padding(.horizontal, 16).frame(height: 56)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(category == c ? Theme.blue : Color.clear, lineWidth: 2)
            }
        }
        .buttonStyle(PressStyle())
    }

    // MARK: 문제 화면

    private func questionView(_ q: QuizQuestion) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Button {
                    questions = []
                } label: {
                    Image(systemName: "xmark").font(.system(size: 16, weight: .semibold)).foregroundStyle(Theme.sub)
                        .frame(width: 36, height: 36)
                }
                Spacer()
                Text("\(index + 1) / \(questions.count)").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.sub).monospacedDigit()
                Spacer()
                Text("\(score)점").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.blue).frame(width: 36)
            }
            .padding(.top, 8)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Theme.fillStrong)
                    Capsule().fill(Theme.blue).frame(width: geo.size.width * CGFloat(index + (picked == nil ? 0 : 1)) / CGFloat(questions.count))
                }
            }
            .frame(height: 6)
            .animation(.spring(duration: 0.4), value: index)
            .animation(.spring(duration: 0.4), value: picked)

            VStack(alignment: .leading, spacing: 12) {
                Text("Q\(index + 1).").font(.system(size: 16, weight: .heavy)).foregroundStyle(Theme.blue)
                Text(q.answer.quiz)
                    .font(.system(size: 19, weight: .bold))
                    .foregroundStyle(Theme.text)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                Text("이 UI의 이름은?").font(.system(size: 14)).foregroundStyle(Theme.sub)
            }
            .cardStyle(padding: 22)

            VStack(spacing: 10) {
                ForEach(q.options) { option in
                    optionButton(option, question: q)
                }
            }

            if let picked {
                let correct = picked == q.answer
                VStack(alignment: .leading, spacing: 10) {
                    Label(correct ? "정답이에요!" : "아쉬워요. 정답은 ‘\(q.answer.ko)’", systemImage: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(correct ? Theme.green : Theme.red)
                    Text(q.answer.summary).font(.system(size: 14)).foregroundStyle(Theme.text)
                        .fixedSize(horizontal: false, vertical: true)
                    NavigationLink(value: q.answer) {
                        Text("‘\(q.answer.ko)’ 눌러보러 가기 →").font(.system(size: 14, weight: .semibold)).foregroundStyle(Theme.blue)
                    }
                }
                .cardStyle(padding: 18)
                .transition(.move(edge: .bottom).combined(with: .opacity))

                Button(index == questions.count - 1 ? "결과 보기" : "다음 문제") { next() }
                    .buttonStyle(DSButtonStyle())
            }
        }
    }

    private func optionButton(_ option: Concept, question q: QuizQuestion) -> some View {
        let isAnswer = option == q.answer
        let isPicked = option == picked
        let revealed = picked != nil
        let bg: Color = !revealed ? Theme.card : (isAnswer ? Theme.greenSoft : (isPicked ? Theme.redSoft : Theme.card))
        let border: Color = !revealed ? Color.clear : (isAnswer ? Theme.green : (isPicked ? Theme.red : Color.clear))
        return Button {
            guard picked == nil else { return }
            withAnimation(.spring(duration: 0.35)) {
                picked = option
                if isAnswer { score += 1 }
            }
            if isAnswer { Haptic.success() } else { Haptic.error() }
        } label: {
            HStack(spacing: 12) {
                ConceptGlyph(concept: option, size: 14)
                VStack(alignment: .leading, spacing: 1) {
                    Text(option.ko).font(.system(size: 16, weight: .bold)).foregroundStyle(Theme.text)
                    Text(option.en).font(.system(size: 12)).foregroundStyle(Theme.sub)
                }
                Spacer()
                if revealed && isAnswer {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(Theme.green).font(.system(size: 20))
                } else if revealed && isPicked {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(Theme.red).font(.system(size: 20))
                }
            }
            .padding(.horizontal, 14).padding(.vertical, 12)
            .background(bg, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(border, lineWidth: 2)
            }
            .opacity(revealed && !isAnswer && !isPicked ? 0.5 : 1)
        }
        .buttonStyle(PressStyle())
    }

    // MARK: 결과 화면

    private var result: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 40)
            Text(score >= 9 ? "🏆" : (score >= 6 ? "🎉" : "💪")).font(.system(size: 72))
            Text("\(questions.count)문제 중 \(score)개 정답!")
                .font(.system(size: 26, weight: .heavy)).foregroundStyle(Theme.text)
            Text(score >= 9 ? "UI 박사네요! 이제 헷갈릴 일 없겠어요." : (score >= 6 ? "잘했어요! 틀린 개념만 한 번 더 눌러봐요." : "괜찮아요. 개념을 직접 눌러보면 금방 익숙해져요."))
                .font(.system(size: 15)).foregroundStyle(Theme.sub).multilineTextAlignment(.center)
            Button("다시 풀기") { start() }.buttonStyle(DSButtonStyle())
            Button("처음으로") { questions = [] }.buttonStyle(DSButtonStyle(kind: .ghost))
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: actions

    private func start() {
        withAnimation(.spring(duration: 0.4)) {
            questions = QuizMaker.make(count: 10, category: category)
            index = 0
            score = 0
            picked = nil
            finished = false
        }
    }

    private func next() {
        withAnimation(.spring(duration: 0.4)) {
            if index < questions.count - 1 {
                index += 1
                picked = nil
            } else {
                finished = true
                progress.recordQuiz(score: score)
            }
        }
    }
}
