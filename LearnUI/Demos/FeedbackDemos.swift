import SwiftUI
import UIKit
import UserNotifications

// MARK: - 배지

struct BadgeDemo: View {
    @State private var count = 3
    @State private var realNote: String? = nil
    @State private var needsSettings = false

    private func applyRealBadge(_ n: Int) {
        NotificationManager.shared.setBadge(n) { result in
            switch result {
            case .ok:
                needsSettings = false
                realNote = n == 0
                    ? "진짜 앱 아이콘의 배지를 지웠어요."
                    : "진짜 앱 아이콘에 배지 \(n)을 달았어요! 홈 화면으로 나가서 ‘UI 도감’ 아이콘 오른쪽 위를 보세요."
            case .denied:
                needsSettings = true
                realNote = "알림 권한이 꺼져 있어서 배지를 달 수 없어요. 아래 ‘알림 설정 열기’에서 알림 허용을 켜주세요."
            case .badgeOff:
                needsSettings = true
                realNote = "알림은 허용됐지만 ‘배지’ 스위치가 꺼져 있어요. 아래 ‘알림 설정 열기’에서 ‘배지’를 켜주세요."
            case .failed(let message):
                needsSettings = false
                realNote = "iOS가 배지 설정을 거절했어요 (\(message)). 예비 방법으로 한 번 더 시도했으니 홈 화면을 확인해 보세요."
            }
        }
    }

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(spacing: 0) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 22) {
                        ForEach(0..<6, id: \.self) { i in
                            VStack(spacing: 6) {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(i == 0 ? Theme.green : Theme.deep(i))
                                    .frame(width: 58, height: 58)
                                    .overlay {
                                        Image(systemName: ["message.fill", "camera.fill", "map.fill", "music.note", "cart.fill", "gearshape.fill"][i])
                                            .font(.system(size: 26)).foregroundStyle(.white)
                                    }
                                    .overlay(alignment: .topTrailing) {
                                        if i == 0 && count > 0 {
                                            CountBadge(count: count).offset(x: 8, y: -8)
                                                .transition(.scale.combined(with: .opacity))
                                        }
                                        if i == 4 {
                                            CountBadge(count: 2).offset(x: 8, y: -8)
                                        }
                                    }
                                Text(["메시지", "카메라", "지도", "음악", "쇼핑", "설정"][i])
                                    .font(.system(size: 11)).foregroundStyle(Theme.text)
                            }
                        }
                    }
                    .padding(.top, 30)
                    .padding(.horizontal, 12)
                    Spacer()
                    HStack {
                        ForEach(0..<4, id: \.self) { i in
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: ["house.fill", "magnifyingglass", "bell.fill", "person.fill"][i])
                                    .font(.system(size: 20))
                                    .foregroundStyle(i == 0 ? Theme.blue : Theme.faint)
                                    .frame(width: 44, height: 30)
                                if i == 2 && count > 0 {
                                    CountBadge(count: count).offset(x: 4, y: -6)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.vertical, 10)
                    .background(Theme.fill)
                }
            }
            HStack(spacing: 8) {
                Button("＋ 새 메시지") {
                    withAnimation(.spring(duration: 0.3, bounce: 0.5)) { count += 1 }
                    Haptic.tap()
                }
                .buttonStyle(DSButtonStyle())
                Button("모두 읽기") { withAnimation(.spring(duration: 0.3)) { count = 0 } }
                    .buttonStyle(DSButtonStyle(kind: .ghost))
            }
            Button("숫자 확 늘리기 (120개)") { withAnimation { count = 120 } }
                .buttonStyle(DSButtonStyle(kind: .ghost, compact: true))
            DemoNote(text: realNote ?? (count > 99 ? "숫자가 너무 크면 ‘99+’로 줄여 보여줘요." : "배지는 ‘몇 개’인지 숫자로 알려줘요. 지금 \(count)개."))
            HStack(spacing: 8) {
                Button { applyRealBadge(max(count, 1)) } label: {
                    Label("진짜 아이콘에 배지 달기", systemImage: "app.badge")
                }
                .buttonStyle(DSButtonStyle(kind: .secondary))
                Button("지우기") { applyRealBadge(0) }
                    .buttonStyle(DSButtonStyle(kind: .ghost))
                    .frame(width: 84)
            }
            if needsSettings {
                Button {
                    if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Label("알림 설정 열기", systemImage: "gearshape")
                }
                .buttonStyle(DSButtonStyle(kind: .primary))
            }
        }
    }
}

// MARK: - 닷

struct DotDemo: View {
    @State private var unread: Set<Int> = [0, 1]
    @State private var note = "빨간 점이 있는 메뉴를 눌러보세요."
    private let menus = [("공지사항", "megaphone.fill"), ("이벤트", "gift.fill"), ("내 정보", "person.fill"), ("설정", "gearshape.fill")]

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 0) {
                    ScreenTitle(text: "전체").padding(.bottom, 10)
                    ForEach(menus.indices, id: \.self) { i in
                        Button {
                            if unread.contains(i) {
                                withAnimation(.spring(duration: 0.3)) { _ = unread.remove(i) }
                                note = "‘\(menus[i].0)’을 확인해서 점이 사라졌어요."
                            } else {
                                note = "‘\(menus[i].0)’에는 새 소식이 없어요."
                            }
                            Haptic.selection()
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: menus[i].1).foregroundStyle(Theme.deep(i)).frame(width: 24)
                                Text(menus[i].0).font(.system(size: 15, weight: .medium)).foregroundStyle(Theme.text)
                                if unread.contains(i) {
                                    RedDot(size: 7).transition(.scale)
                                }
                                Spacer()
                                Image(systemName: "chevron.right").font(.system(size: 13)).foregroundStyle(Theme.faint)
                            }
                            .frame(height: 52)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                    HStack {
                        ForEach(0..<4, id: \.self) { i in
                            Image(systemName: ["house.fill", "magnifyingglass", "bell.fill", "line.3.horizontal"][i])
                                .font(.system(size: 20))
                                .foregroundStyle(i == 3 ? Theme.blue : Theme.faint)
                                .overlay(alignment: .topTrailing) {
                                    if i == 3 && !unread.isEmpty { RedDot(size: 7).offset(x: 5, y: -2) }
                                }
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.vertical, 12)
                }
                .padding(.horizontal, 16)
            }
            Button("새 소식 도착") {
                withAnimation(.spring(duration: 0.3)) { unread = [0, 1] }
                note = "숫자는 없고 ‘새로운 게 있다’는 것만 알려줘요. 아래 탭에도 점이 생겼죠?"
            }
            .buttonStyle(DSButtonStyle(kind: .ghost))
            DemoNote(text: note)
        }
    }
}

// MARK: - 진행 바

struct ProgressBarDemo: View {
    @State private var progress: Double = 0
    @State private var running = false

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 16) {
                    ScreenTitle(text: "다운로드")
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "doc.zipper").font(.system(size: 22)).foregroundStyle(Theme.blue)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("여행사진_모음.zip").font(.system(size: 14, weight: .semibold)).foregroundStyle(Theme.text)
                                Text(statusText).font(.system(size: 12)).foregroundStyle(Theme.sub).monospacedDigit()
                            }
                            Spacer()
                            Text("\(Int(progress * 100))%").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.blue).monospacedDigit()
                        }
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Theme.fill)
                                Capsule().fill(progress >= 1 ? Theme.green : Theme.blue)
                                    .frame(width: max(8, geo.size.width * progress))
                            }
                        }
                        .frame(height: 8)
                    }
                    .padding(16)
                    .background(Theme.fill.opacity(0.5), in: RoundedRectangle(cornerRadius: 16))

                    HStack(spacing: 16) {
                        ZStack {
                            Circle().stroke(Theme.fill, lineWidth: 8)
                            Circle().trim(from: 0, to: progress)
                                .stroke(progress >= 1 ? Theme.green : Theme.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                            Text("\(Int(progress * 100))").font(.system(size: 16, weight: .bold)).monospacedDigit().foregroundStyle(Theme.text)
                        }
                        .frame(width: 64, height: 64)
                        Text("원형으로 그려도 ‘얼마나 찼는지’를 보여주면 진행 바(프로그레스)예요.")
                            .font(.system(size: 12)).foregroundStyle(Theme.sub)
                    }
                    Spacer()
                }
                .padding(16)
            }
            HStack(spacing: 8) {
                Button(running ? "받는 중…" : (progress >= 1 ? "다시 받기" : "다운로드")) { start() }
                    .buttonStyle(DSButtonStyle())
                    .disabled(running)
            }
            DemoNote(text: "진행 바는 끝이 정해져 있어서 ‘얼마나 남았는지’ 예측할 수 있어요.")
        }
    }

    private var statusText: String {
        if progress >= 1 { return "완료!" }
        if !running { return "48.2MB · 대기 중" }
        let left = Int((1 - progress) * 8) + 1
        return String(format: "%.1fMB / 48.2MB · 약 %d초 남음", progress * 48.2, left)
    }

    private func start() {
        guard !running else { return }
        running = true
        progress = 0
        Task { @MainActor in
            while progress < 1 {
                try? await Task.sleep(nanoseconds: 70_000_000)
                withAnimation(.linear(duration: 0.07)) { progress = min(1, progress + Double.random(in: 0.005...0.025)) }
            }
            running = false
            Haptic.success()
        }
    }
}

// MARK: - 단계 표시

struct StepsDemo: View {
    @State private var step = 0
    @State private var agree = false
    @State private var name = ""
    private let titles = ["약관 동의", "정보 입력", "가입 완료"]

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 18) {
                    ScreenTitle(text: "회원가입")
                    HStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) { i in
                            VStack(spacing: 6) {
                                ZStack {
                                    Circle().fill(i <= step ? Theme.blue : Theme.fill).frame(width: 30, height: 30)
                                    if i < step {
                                        Image(systemName: "checkmark").font(.system(size: 13, weight: .bold)).foregroundStyle(.white)
                                    } else {
                                        Text("\(i + 1)").font(.system(size: 14, weight: .bold)).foregroundStyle(i == step ? .white : Theme.faint)
                                    }
                                }
                                Text(titles[i]).font(.system(size: 11, weight: i == step ? .bold : .regular)).foregroundStyle(i == step ? Theme.blue : Theme.sub)
                            }
                            .frame(width: 62)
                            if i < 2 {
                                Rectangle().fill(i < step ? Theme.blue : Theme.fill).frame(height: 3)
                                    .padding(.bottom, 20)
                            }
                        }
                    }
                    .animation(.spring(duration: 0.35), value: step)

                    Group {
                        switch step {
                        case 0:
                            VStack(alignment: .leading, spacing: 12) {
                                Text("서비스 이용약관에\n동의해 주세요").font(.system(size: 18, weight: .bold)).foregroundStyle(Theme.text)
                                Button { agree.toggle() } label: {
                                    HStack { CheckMark(on: agree); Text("필수 약관 전체 동의").foregroundStyle(Theme.text) }
                                }
                                .buttonStyle(.plain)
                            }
                        case 1:
                            VStack(alignment: .leading, spacing: 12) {
                                Text("이름을 알려주세요").font(.system(size: 18, weight: .bold)).foregroundStyle(Theme.text)
                                FieldBox { TextField("홍길동", text: $name) }
                            }
                        default:
                            VStack(spacing: 10) {
                                Image(systemName: "party.popper.fill").font(.system(size: 44)).foregroundStyle(Theme.orange)
                                Text("\(name.isEmpty ? "우디" : name)님, 환영해요!").font(.system(size: 18, weight: .bold)).foregroundStyle(Theme.text)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 10)
                        }
                    }
                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .opacity))
                    .id(step)
                    Spacer()
                    HStack(spacing: 8) {
                        if step > 0 && step < 2 {
                            Button("이전") { withAnimation(.spring(duration: 0.35)) { step -= 1 } }
                                .buttonStyle(DSButtonStyle(kind: .ghost))
                                .frame(width: 80)
                        }
                        Button(step == 2 ? "처음부터" : "다음") {
                            withAnimation(.spring(duration: 0.35)) {
                                if step == 2 { step = 0; agree = false; name = "" } else { step += 1 }
                            }
                        }
                        .buttonStyle(DSButtonStyle())
                        .disabled(step == 0 && !agree)
                        .opacity(step == 0 && !agree ? 0.4 : 1)
                    }
                }
                .padding(16)
            }
            DemoNote(text: "지금 \(titles.count)단계 중 \(step + 1)번째 ‘\(titles[step])’ 단계예요. 단계마다 이름이 있어요.")
        }
    }
}

// MARK: - 스피너

struct SpinnerDemo: View {
    @State private var loading = false
    @State private var loaded = false
    @State private var temp = 18

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(spacing: 16) {
                    ScreenTitle(text: "날씨")
                    ZStack {
                        RoundedRectangle(cornerRadius: 20).fill(LinearGradient(colors: [Color(hex: 0x5AA9FF), Color(hex: 0x3182F6)], startPoint: .top, endPoint: .bottom))
                        if loading {
                            VStack(spacing: 12) {
                                ProgressView().controlSize(.large).tint(.white)
                                Text("불러오는 중…").font(.system(size: 13, weight: .medium)).foregroundStyle(.white.opacity(0.9))
                            }
                            .transition(.opacity)
                        } else if loaded {
                            VStack(spacing: 4) {
                                Image(systemName: "sun.max.fill").font(.system(size: 40)).symbolRenderingMode(.multicolor)
                                Text("\(temp)°").font(.system(size: 48, weight: .bold)).foregroundStyle(.white)
                                Text("서울 · 맑음").font(.system(size: 14, weight: .semibold)).foregroundStyle(.white.opacity(0.9))
                            }
                            .transition(.scale(scale: 0.9).combined(with: .opacity))
                        } else {
                            Text("아직 불러오지 않았어요").font(.system(size: 14)).foregroundStyle(.white.opacity(0.85))
                        }
                    }
                    .frame(height: 220)
                    Spacer()
                    Button(loading ? "기다리는 중…" : "날씨 불러오기") { load() }
                        .buttonStyle(DSButtonStyle())
                        .disabled(loading)
                }
                .padding(16)
            }
            DemoNote(text: loading ? "언제 끝날지 모르지만 ‘멈추지 않았어요’라고 알려주는 중이에요." : "스피너는 진행률을 모를 때 써요. 버튼을 눌러보세요.")
        }
    }

    private func load() {
        withAnimation { loading = true; loaded = false }
        delay(Double.random(in: 1.4...2.4)) {
            temp = Int.random(in: 8...24)
            withAnimation(.spring(duration: 0.4)) { loading = false; loaded = true }
        }
    }
}

// MARK: - 스켈레톤

struct SkeletonDemo: View {
    @State private var loading = true

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 18) {
                    ScreenTitle(text: "피드")
                    ForEach(0..<3, id: \.self) { i in
                        if loading {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 10) {
                                    Circle().fill(Theme.fill).frame(width: 36, height: 36)
                                    VStack(alignment: .leading, spacing: 6) {
                                        SkeletonBar(width: 90, height: 10)
                                        SkeletonBar(width: 60, height: 8)
                                    }
                                }
                                RoundedRectangle(cornerRadius: 12).fill(Theme.fill).frame(height: 56)
                            }
                            .shimmer()
                            .transition(.opacity)
                        } else {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 10) {
                                    Circle().fill(Theme.pastel(i)).frame(width: 36, height: 36)
                                        .overlay(Text(["🐶", "🐱", "🐰"][i]))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(["멍멍이", "야옹이", "토끼"][i]).font(.system(size: 14, weight: .semibold)).foregroundStyle(Theme.text)
                                        Text("\(i + 2)분 전").font(.system(size: 11)).foregroundStyle(Theme.sub)
                                    }
                                }
                                Text(["오늘 산책 다녀왔어요! 날씨 최고", "햇살 맛집 발견 ☀️ 낮잠 자기 딱 좋아요", "당근 먹방 찍었어요 🥕"][i])
                                    .font(.system(size: 13)).foregroundStyle(Theme.text)
                                    .padding(12)
                                    .frame(maxWidth: .infinity, minHeight: 56, alignment: .topLeading)
                                    .background(Theme.pastel(i), in: RoundedRectangle(cornerRadius: 12))
                            }
                            .transition(.opacity)
                        }
                    }
                    Spacer(minLength: 0)
                }
                .padding(16)
                .animation(.easeInOut(duration: 0.4), value: loading)
            }
            Button("다시 불러오기") { reload() }
                .buttonStyle(DSButtonStyle())
            DemoNote(text: loading ? "회색 뼈대가 실제 내용과 같은 모양이라 ‘곧 이런 게 나오겠구나’ 예상할 수 있어요." : "뼈대가 있던 자리에 그대로 진짜 내용이 채워졌어요.")
        }
        .onAppear { delay(2.2) { loading = false } }
    }

    private func reload() {
        loading = true
        delay(2.2) { loading = false }
    }
}

// MARK: - 빈 화면

struct EmptyStateDemo: View {
    @State private var memos: [String] = []
    private let samples = ["장보기: 우유, 계란", "UI 도감 다 보기", "운동 30분", "책 20쪽 읽기", "엄마한테 전화"]

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        ScreenTitle(text: "메모")
                        if !memos.isEmpty {
                            Button { add() } label: { IconTile(symbol: "plus", tint: Theme.blue) }
                        }
                    }
                    if memos.isEmpty {
                        Spacer()
                        VStack(spacing: 12) {
                            Circle().fill(Theme.blueSoft).frame(width: 96, height: 96)
                                .overlay(Image(systemName: "note.text").font(.system(size: 40)).foregroundStyle(Theme.blue))
                            Text("아직 메모가 없어요").font(.system(size: 17, weight: .bold)).foregroundStyle(Theme.text)
                            Text("생각나는 걸 가볍게 적어보세요").font(.system(size: 13)).foregroundStyle(Theme.sub)
                            Button("첫 메모 쓰기") { add() }
                                .buttonStyle(DSButtonStyle(kind: .primary, compact: true))
                                .padding(.top, 4)
                        }
                        .frame(maxWidth: .infinity)
                        .transition(.scale(scale: 0.9).combined(with: .opacity))
                        Spacer()
                    } else {
                        ForEach(memos, id: \.self) { m in
                            HStack {
                                Text(m).font(.system(size: 14)).foregroundStyle(Theme.text)
                                Spacer()
                                Button { withAnimation(.spring(duration: 0.3)) { memos.removeAll { $0 == m } } } label: {
                                    Image(systemName: "xmark.circle.fill").foregroundStyle(Theme.faint)
                                }
                            }
                            .padding(14)
                            .background(Theme.fill, in: RoundedRectangle(cornerRadius: 12))
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                        Spacer(minLength: 0)
                    }
                }
                .padding(16)
            }
            Button("모두 지우기") { withAnimation(.spring(duration: 0.35)) { memos = [] } }
                .buttonStyle(DSButtonStyle(kind: .ghost))
                .disabled(memos.isEmpty)
            DemoNote(text: memos.isEmpty ? "그냥 하얀 화면 대신, 왜 비었는지와 다음에 할 일을 알려줘요." : "메모를 다 지우면 다시 빈 화면 안내가 나와요.")
        }
    }

    private func add() {
        let next = samples.first { !memos.contains($0) } ?? "새 메모 \(memos.count + 1)"
        withAnimation(.spring(duration: 0.35)) { memos.insert(next, at: 0) }
    }
}

// MARK: - 당겨서 새로고침

struct PullToRefreshDemo: View {
    struct Item: Identifiable { let id: Int; let text: String }
    @State private var items: [Item] = (0..<6).map { Item(id: $0, text: "이전 글 #\(6 - $0)") }
    @State private var counter = 7
    @State private var refreshed = 0

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(spacing: 0) {
                    ScreenTitle(text: "타임라인").padding(.horizontal, 16).padding(.bottom, 6)
                    List {
                        ForEach(items) { item in
                            MockRow(index: item.id, title: item.text, subtitle: item.id >= 6 ? "방금 새로 불러옴 ✨" : "1시간 전", symbol: "text.bubble.fill")
                                .listRowBackground(item.id >= 6 && item.id == items.first?.id ? Theme.blueSoft : Theme.card)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .refreshable {
                        try? await Task.sleep(nanoseconds: 1_200_000_000)
                        await MainActor.run {
                            withAnimation {
                                items.insert(Item(id: counter, text: "새 글 #\(counter)"), at: 0)
                                counter += 1
                                refreshed += 1
                            }
                            Haptic.success()
                        }
                    }
                }
            }
            DemoNote(text: refreshed == 0 ? "목록을 맨 위에서 아래로 쭉 당겼다 놓아보세요." : "새 글이 맨 위에 추가됐어요! (\(refreshed)번 새로고침)")
        }
    }
}

// MARK: - 햅틱

struct HapticDemo: View {
    @State private var last: String = ""
    @State private var pulse = 0
    private let kinds: [(String, String, Color)] = [
        ("성공", "checkmark.circle.fill", Theme.green),
        ("경고", "exclamationmark.triangle.fill", Theme.orange),
        ("실패", "xmark.octagon.fill", Theme.red),
        ("선택", "hand.tap.fill", Theme.blue),
        ("가볍게", "circle.dotted", Color(hex: 0x8B5CF6)),
        ("묵직하게", "circle.fill", Color(hex: 0x333D4B)),
    ]

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 14) {
                    ScreenTitle(text: "진동 느껴보기")
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                        ForEach(kinds.indices, id: \.self) { i in
                            let k = kinds[i]
                            Button { fire(i) } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: k.1).font(.system(size: 28)).foregroundStyle(k.2)
                                        .symbolEffect(.bounce, value: last == k.0 ? pulse : 0)
                                    Text(k.0).font(.system(size: 14, weight: .semibold)).foregroundStyle(Theme.text)
                                }
                                .frame(maxWidth: .infinity).frame(height: 96)
                                .background(last == k.0 ? k.2.opacity(0.15) : Theme.fill, in: RoundedRectangle(cornerRadius: 16))
                            }
                            .buttonStyle(PressStyle())
                        }
                    }
                    Spacer(minLength: 0)
                }
                .padding(16)
            }
            DemoNote(text: last.isEmpty ? "휴대폰을 손에 쥐고 눌러보세요. 무음 모드여도 대부분 느껴져요." : "‘\(last)’ 진동이었어요. 종류마다 손끝 느낌이 달라요.")
        }
    }

    private func fire(_ i: Int) {
        switch i {
        case 0: Haptic.success()
        case 1: Haptic.warning()
        case 2: Haptic.error()
        case 3: Haptic.selection()
        case 4: Haptic.impact(.light)
        default: Haptic.impact(.heavy)
        }
        last = kinds[i].0
        pulse += 1
    }
}

// MARK: - 온보딩

struct OnboardingDemo: View {
    @State private var page = 0
    @State private var done = false
    private let pages: [(String, String, String, Color)] = [
        ("hand.tap.fill", "눌러보며 배워요", "모든 UI를 직접 만져볼 수 있어요", Theme.blue),
        ("square.on.square", "헷갈리는 짝 비교", "비슷한 UI를 나란히 비교해요", Color(hex: 0x8B5CF6)),
        ("checkmark.seal.fill", "퀴즈로 확인", "배운 걸 퀴즈로 점검해요", Theme.green),
    ]

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack {
                    if done {
                        VStack(spacing: 12) {
                            ScreenTitle(text: "홈")
                            ForEach(0..<3, id: \.self) { i in MockRow(index: i, title: "콘텐츠 \(i + 1)", subtitle: "온보딩이 끝나고 진짜 앱 화면") }
                            Spacer()
                            Button("온보딩 다시 보기") {
                                withAnimation(.spring(duration: 0.4)) { done = false; page = 0 }
                            }
                            .buttonStyle(DSButtonStyle(kind: .ghost))
                        }
                        .padding(16)
                        .transition(.opacity)
                    } else {
                        VStack(spacing: 0) {
                            HStack {
                                Spacer()
                                Button("건너뛰기") { finish() }
                                    .font(.system(size: 14, weight: .medium)).foregroundStyle(Theme.sub)
                            }
                            .padding(.horizontal, 18)
                            TabView(selection: $page) {
                                ForEach(pages.indices, id: \.self) { i in
                                    let p = pages[i]
                                    VStack(spacing: 16) {
                                        Circle().fill(p.3.opacity(0.15)).frame(width: 130, height: 130)
                                            .overlay(Image(systemName: p.0).font(.system(size: 54)).foregroundStyle(p.3))
                                        Text(p.1).font(.system(size: 22, weight: .bold)).foregroundStyle(Theme.text)
                                        Text(p.2).font(.system(size: 14)).foregroundStyle(Theme.sub)
                                    }
                                    .tag(i)
                                }
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            HStack(spacing: 6) {
                                ForEach(pages.indices, id: \.self) { i in
                                    Capsule().fill(i == page ? Theme.blue : Theme.fillStrong)
                                        .frame(width: i == page ? 18 : 7, height: 7)
                                }
                            }
                            .animation(.spring(duration: 0.3), value: page)
                            .padding(.bottom, 16)
                            Button(page == pages.count - 1 ? "시작하기" : "다음") {
                                if page == pages.count - 1 { finish() } else { withAnimation { page += 1 } }
                            }
                            .buttonStyle(DSButtonStyle())
                            .padding(16)
                        }
                        .transition(.opacity)
                    }
                }
            }
            DemoNote(text: done ? "온보딩은 앱을 쓰기 ‘전’에 보는 별도의 소개 화면이에요." : "옆으로 넘기거나 ‘다음’을 눌러보세요. 아래 점이 위치를 알려줘요.")
        }
    }

    private func finish() { withAnimation(.spring(duration: 0.4)) { done = true } }
}

// MARK: - 코치마크

struct SpotlightKey: PreferenceKey {
    static let defaultValue: [Int: Anchor<CGRect>] = [:]
    static func reduce(value: inout [Int: Anchor<CGRect>], nextValue: () -> [Int: Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}

extension View {
    func spotlight(_ id: Int) -> some View {
        anchorPreference(key: SpotlightKey.self, value: .bounds) { [id: $0] }
    }
}

struct CoachMarkDemo: View {
    @State private var step: Int? = nil
    private let tips = ["여기를 눌러 새 글을 쓸 수 있어요", "궁금한 건 여기서 검색해요", "내 정보와 설정은 여기 있어요"]

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack(alignment: .bottomTrailing) {
                    VStack(spacing: 0) {
                        HStack {
                            ScreenTitle(text: "커뮤니티")
                            IconTile(symbol: "magnifyingglass").spotlight(1)
                        }
                        .padding(.horizontal, 16)
                        VStack(spacing: 12) {
                            ForEach(0..<4, id: \.self) { i in
                                MockRow(index: i, title: ["오늘 점심 뭐 먹지?", "UI 공부 같이 해요", "주말 등산 모집", "고양이 자랑"][i], subtitle: "댓글 \(i * 3 + 2)")
                            }
                        }
                        .padding(16)
                        Spacer()
                        HStack {
                            ForEach(0..<4, id: \.self) { i in
                                let icon = Image(systemName: ["house.fill", "bubble.left.and.bubble.right.fill", "bell.fill", "person.fill"][i])
                                    .font(.system(size: 20))
                                    .foregroundStyle(i == 1 ? Theme.blue : Theme.faint)
                                    .frame(width: 44, height: 34)
                                Group {
                                    if i == 3 { icon.spotlight(2) } else { icon }
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.vertical, 8)
                        .background(Theme.fill)
                    }
                    Circle().fill(Theme.blue).frame(width: 52, height: 52)
                        .overlay(Image(systemName: "plus").font(.system(size: 22, weight: .bold)).foregroundStyle(.white))
                        .shadow(color: Theme.blue.opacity(0.4), radius: 10, y: 4)
                        .spotlight(0)
                        .padding(.trailing, 16)
                        .padding(.bottom, 66)
                }
                .overlayPreferenceValue(SpotlightKey.self) { anchors in
                    GeometryReader { proxy in
                        if let s = step, let anchor = anchors[s] {
                            let rect = proxy[anchor].insetBy(dx: -8, dy: -8)
                            let below = rect.midY < proxy.size.height / 2
                            ZStack(alignment: .topLeading) {
                                Path { p in
                                    p.addRect(CGRect(origin: .zero, size: proxy.size))
                                    p.addRoundedRect(in: rect, cornerSize: CGSize(width: 16, height: 16))
                                }
                                .fill(Color.black.opacity(0.65), style: FillStyle(eoFill: true))

                                RoundedRectangle(cornerRadius: 16).strokeBorder(.white.opacity(0.9), lineWidth: 2)
                                    .frame(width: rect.width, height: rect.height)
                                    .offset(x: rect.minX, y: rect.minY)

                                VStack(alignment: .leading, spacing: 8) {
                                    Text("\(s + 1) / \(tips.count)").font(.system(size: 11, weight: .bold)).foregroundStyle(Theme.blue)
                                    Text(tips[s]).font(.system(size: 14, weight: .semibold)).foregroundStyle(Theme.text)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text(s == tips.count - 1 ? "탭해서 끝내기" : "탭해서 다음").font(.system(size: 11)).foregroundStyle(Theme.sub)
                                }
                                .padding(14)
                                .frame(width: 190, alignment: .leading)
                                .background(Theme.card, in: RoundedRectangle(cornerRadius: 14))
                                .position(
                                    x: min(max(rect.midX, 105), proxy.size.width - 105),
                                    y: below ? rect.maxY + 56 : rect.minY - 56
                                )
                            }
                            .contentShape(Rectangle())
                            .onTapGesture { next() }
                            .transition(.opacity)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: step)
            }
            Button(step == nil ? "사용법 보기" : "안내 닫기") {
                if step == nil { step = 0 } else { step = nil }
            }
            .buttonStyle(DSButtonStyle())
            DemoNote(text: step == nil ? "‘사용법 보기’를 눌러 코치마크를 띄워보세요." : "실제 화면 위에서 한 곳만 밝게 비춰요. 화면을 탭하면 다음으로 넘어가요.")
        }
    }

    private func next() {
        if let s = step, s < tips.count - 1 { step = s + 1 } else { step = nil }
    }
}

// MARK: - Notification helper

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    func setup() {
        UNUserNotificationCenter.current().delegate = self
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .list])
    }

    func schedule(after seconds: TimeInterval, title: String, body: String, completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else {
                DispatchQueue.main.async { completion(false) }
                return
            }
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
            center.add(UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger))
            DispatchQueue.main.async { completion(true) }
        }
    }

    enum BadgeResult { case ok, denied, badgeOff, failed(String) }

    /// 앱 아이콘 배지 숫자를 바꿔요. 권한·설정 상태를 확인해서 왜 안 되는지도 알려줘요.
    func setBadge(_ count: Int, completion: @escaping (BadgeResult) -> Void) {
        let center = UNUserNotificationCenter.current()
        let finish: (BadgeResult) -> Void = { r in DispatchQueue.main.async { completion(r) } }

        func apply() {
            center.getNotificationSettings { settings in
                if settings.authorizationStatus == .denied { finish(.denied); return }
                if settings.badgeSetting == .disabled { finish(.badgeOff); return }
                center.setBadgeCount(count) { error in
                    if let error {
                        // 예비 방법: 예전 API로 한 번 더 시도
                        DispatchQueue.main.async { UIApplication.shared.applicationIconBadgeNumber = count }
                        finish(.failed(error.localizedDescription))
                    } else {
                        finish(.ok)
                    }
                }
            }
        }

        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                center.requestAuthorization(options: [.badge, .alert, .sound]) { _, _ in apply() }
            } else {
                apply()
            }
        }
    }
}
