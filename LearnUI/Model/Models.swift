import SwiftUI

enum ConceptCategory: String, CaseIterable, Identifiable, Hashable {
    case overlay, feedback, input, navigation, icon

    var id: String { rawValue }

    var title: String {
        switch self {
        case .overlay: return "알림·오버레이"
        case .feedback: return "상태·피드백"
        case .input: return "입력·선택"
        case .navigation: return "이동·레이아웃"
        case .icon: return "아이콘"
        }
    }

    var subtitle: String {
        switch self {
        case .overlay: return "화면 위에 무언가 뜨는 것들"
        case .feedback: return "지금 상태를 알려주는 것들"
        case .input: return "값을 입력하고 고르는 것들"
        case .navigation: return "화면을 옮기고 배치하는 것들"
        case .icon: return "닮았는데 뜻은 다른 아이콘들"
        }
    }

    var symbol: String {
        switch self {
        case .overlay: return "square.stack.3d.up.fill"
        case .feedback: return "bell.badge.fill"
        case .input: return "character.cursor.ibeam"
        case .navigation: return "rectangle.split.3x1.fill"
        case .icon: return "star.square.on.square.fill"
        }
    }
}

struct Concept: Identifiable, Hashable {
    let id: String
    let ko: String
    let en: String
    let category: ConceptCategory
    let symbol: String
    var rotation: Double = 0
    /// 한 줄 요약
    let summary: String
    /// 자세한 설명
    let detail: String
    /// 이럴 때 써요
    let whenToUse: [String]
    /// 핵심 포인트
    let points: [String]
    /// 데모에서 해볼 것
    let hint: String
    /// 퀴즈용 상황 설명 (이름이 들어가면 안 됨)
    let quiz: String
}

struct ConceptPair: Identifiable, Hashable {
    let a: String
    let b: String
    /// 한 줄로 구분하는 법
    let headline: String
    let points: [String]
    var id: String { a + "|" + b }
}

enum Library {
    static let concepts: [Concept] = overlayConcepts + feedbackConcepts + inputConcepts + navigationConcepts + iconConcepts

    static let byID: [String: Concept] = {
        var dict: [String: Concept] = [:]
        for c in concepts { dict[c.id] = c }
        return dict
    }()

    static func concept(_ id: String) -> Concept? { byID[id] }

    static func concepts(in category: ConceptCategory) -> [Concept] {
        concepts.filter { $0.category == category }
    }

    static func number(of concept: Concept) -> Int {
        (concepts(in: concept.category).firstIndex(of: concept) ?? 0) + 1
    }

    static func pairs(for id: String) -> [ConceptPair] {
        pairs.filter { $0.a == id || $0.b == id }
    }

    static func partner(of id: String, in pair: ConceptPair) -> Concept? {
        concept(pair.a == id ? pair.b : pair.a)
    }
}

// MARK: - 학습 진도

final class ProgressStore: ObservableObject {
    @Published private(set) var seen: Set<String>
    @Published var bestQuizScore: Int

    private let key = "seenConcepts"
    private let quizKey = "bestQuizScore"

    init() {
        seen = Set(UserDefaults.standard.stringArray(forKey: key) ?? [])
        bestQuizScore = UserDefaults.standard.integer(forKey: quizKey)
    }

    func markSeen(_ id: String) {
        guard !seen.contains(id) else { return }
        seen.insert(id)
        UserDefaults.standard.set(Array(seen), forKey: key)
    }

    func recordQuiz(score: Int) {
        if score > bestQuizScore {
            bestQuizScore = score
            UserDefaults.standard.set(score, forKey: quizKey)
        }
    }

    func reset() {
        seen = []
        UserDefaults.standard.removeObject(forKey: key)
    }
}
