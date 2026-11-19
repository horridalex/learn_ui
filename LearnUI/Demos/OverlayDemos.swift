import SwiftUI
import UIKit

// MARK: - 팝업

struct PopupDemo: View {
    @State private var show = false
    @State private var hideToday = false
    @State private var taps = 0
    @State private var note = "팝업은 내가 부르지 않았는데 떠요. 뒤 화면도 그대로 눌려요."

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack {
                    VStack(alignment: .leading, spacing: 12) {
                        ScreenTitle(text: "홈")
                        Button { taps += 1; Haptic.tap() } label: {
                            Label("뒤 화면 버튼 · \(taps)번 눌림", systemImage: "hand.tap")
                        }
                        .buttonStyle(DSButtonStyle(kind: .ghost, compact: true))
                        ForEach(0..<4, id: \.self) { i in
                            MockRow(index: i, title: ["이번 달 소비", "내 계좌", "적금 만기", "포인트"][i], subtitle: "자세히 보기", symbol: ["chart.pie.fill", "creditcard.fill", "banknote.fill", "star.fill"][i])
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(16)

                    if show {
                        popupWindow
                            .padding(.top, 60)
                            .frame(maxHeight: .infinity, alignment: .top)
                            .transition(.scale(scale: 0.85).combined(with: .opacity))
                    }
                }
            }
            Button("앱 다시 열기") { reopen() }
                .buttonStyle(DSButtonStyle())
            DemoNote(text: note)
        }
        .onAppear { delay(0.6) { reopen() } }
    }

    private var popupWindow: some View {
        VStack(spacing: 0) {
            ZStack {
                LinearGradient(colors: [Color(hex: 0x6E8BFF), Color(hex: 0xB06BFF)], startPoint: .topLeading, endPoint: .bottomTrailing)
                VStack(spacing: 6) {
                    Text("🎁").font(.system(size: 40))
                    Text("11월 혜택").font(.system(size: 14, weight: .semibold)).foregroundStyle(.white.opacity(0.85))
                    Text("최대 50% 할인").font(.system(size: 22, weight: .heavy)).foregroundStyle(.white)
                }
            }
            .frame(height: 180)
            HStack(spacing: 0) {
                Button("오늘 하루 보지 않기") {
                    hideToday = true
                    close("‘오늘 하루 보지 않기’를 눌렀어요. 이제 앱을 다시 열어도 팝업이 안 떠요.")
                }
                .frame(maxWidth: .infinity)
                Rectangle().fill(Theme.fillStrong).frame(width: 1, height: 20)
                Button("닫기") { close("팝업을 닫았어요. 앱을 다시 열면 또 떠요.") }
                    .frame(maxWidth: .infinity)
            }
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(Theme.sub)
            .frame(height: 46)
            .background(Theme.card)
        }
        .frame(width: 220)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.25), radius: 24, y: 10)
    }

    private func close(_ message: String) {
        withAnimation(.spring(duration: 0.3)) { show = false }
        note = message
    }

    private func reopen() {
        if hideToday {
            note = "오늘은 팝업이 뜨지 않아요. (한 번 더 누르면 초기화)"
            hideToday = false
            return
        }
        withAnimation(.spring(duration: 0.4, bounce: 0.3)) { show = true }
        note = "팝업이 떴어요! 닫지 않고 뒤 화면 버튼을 눌러보세요. 그대로 눌려요."
    }
}

// MARK: - 모달

struct ModalDemo: View {
    @State private var show = false
    @State private var shake: CGFloat = 0
    @State private var native = false
    @State private var note = "‘회원 탈퇴하기’를 눌러 모달을 띄워보세요."

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack {
                    VStack(alignment: .leading, spacing: 14) {
                        ScreenTitle(text: "설정")
                        MockRow(index: 1, title: "알림", subtitle: "켜짐", symbol: "bell.fill")
                        MockRow(index: 2, title: "개인정보", subtitle: "보호 중", symbol: "lock.fill")
                        MockRow(index: 4, title: "고객센터", subtitle: "24시간", symbol: "headphones")
                        Spacer(minLength: 0)
                        Button("회원 탈퇴하기") {
                            withAnimation(.spring(duration: 0.35)) { show = true }
                            note = "뒤의 어두운 부분을 눌러보세요. 아무것도 눌리지 않아요."
                        }
                        .buttonStyle(DSButtonStyle(kind: .ghost))
                    }
                    .padding(16)

                    if show {
                        Color.black.opacity(0.45)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                Haptic.warning()
                                withAnimation(.linear(duration: 0.45)) { shake += 1 }
                                note = "뒤 화면은 막혀 있어요! 모달 안의 버튼으로만 닫을 수 있어요."
                            }
                            .transition(.opacity)

                        VStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 28)).foregroundStyle(Theme.orange)
                            Text("정말 탈퇴할까요?").font(.system(size: 17, weight: .bold)).foregroundStyle(Theme.text)
                            Text("탈퇴하면 모든 기록이 사라져요.")
                                .font(.system(size: 13)).foregroundStyle(Theme.sub)
                            HStack(spacing: 8) {
                                Button("취소") { dismiss("취소했어요. 모달이 닫히고 뒤 화면을 다시 쓸 수 있어요.") }
                                    .buttonStyle(DSButtonStyle(kind: .ghost))
                                Button("탈퇴") { dismiss("탈퇴를 선택했어요. 모달은 결정을 받아야 닫혀요.") }
                                    .buttonStyle(DSButtonStyle(kind: .danger))
                            }
                            .padding(.top, 6)
                        }
                        .padding(20)
                        .background(Theme.card, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .padding(.horizontal, 18)
                        .modifier(ShakeEffect(animatableData: shake))
                        .transition(.scale(scale: 0.9).combined(with: .opacity))
                    }
                }
            }
            DemoNote(text: note)
            NativeButton(title: "iOS 기본 전체 화면 모달 띄우기") { native = true }
        }
        .fullScreenCover(isPresented: $native) { NativeModalScreen() }
    }

    private func dismiss(_ message: String) {
        withAnimation(.spring(duration: 0.3)) { show = false }
        note = message
    }
}

struct NativeModalScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("이 화면은 iOS의 진짜 전체 화면 모달이에요.\n뒤에 있던 화면은 이 창을 닫기 전까지 쓸 수 없어요.")
                    .font(.system(size: 15)).foregroundStyle(Theme.sub)
                FieldBox {
                    TextField("제목을 입력해보세요", text: $title)
                }
                Spacer()
                Button("완료하고 닫기") { dismiss() }
                    .buttonStyle(DSButtonStyle())
            }
            .padding(20)
            .background(Theme.bg)
            .navigationTitle("새 글 쓰기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { dismiss() }
                }
            }
        }
    }
}

// MARK: - iOS 스타일 알럿 박스 (알럿/컨펌 공용)

struct AlertAction {
    let title: String
    var bold = false
    var destructive = false
    let action: () -> Void
}

struct MockAlertBox: View {
    let title: String
    let message: String
    let actions: [AlertAction]

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {
                Text(title).font(.system(size: 16, weight: .semibold))
                Text(message).font(.system(size: 13)).multilineTextAlignment(.center)
            }
            .foregroundStyle(Theme.text)
            .padding(.horizontal, 16)
            .padding(.vertical, 18)

            Rectangle().fill(Theme.fillStrong).frame(height: 0.5)

            HStack(spacing: 0) {
                ForEach(Array(actions.enumerated()), id: \.offset) { idx, a in
                    if idx > 0 { Rectangle().fill(Theme.fillStrong).frame(width: 0.5) }
                    Button(action: a.action) {
                        Text(a.title)
                            .font(.system(size: 16, weight: a.bold ? .semibold : .regular))
                            .foregroundStyle(a.destructive ? Theme.red : Theme.blue)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(height: 44)
        }
        .frame(width: 232)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 20, y: 8)
    }
}

// MARK: - 알럿

struct AlertDemo: View {
    @State private var show = false
    @State private var paid = false
    @State private var native = false

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack {
                    VStack(spacing: 14) {
                        ScreenTitle(text: "주문하기")
                        HStack {
                            MockRow(index: 3, title: "아이스 아메리카노", subtitle: "1잔", symbol: "cup.and.saucer.fill")
                            Text("4,500원").font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
                        }
                        Spacer()
                        if paid {
                            Label("결제 완료", systemImage: "checkmark.circle.fill")
                                .font(.system(size: 15, weight: .semibold)).foregroundStyle(Theme.green)
                        }
                        Button(paid ? "다시 결제하기" : "4,500원 결제하기") {
                            withAnimation(.spring(duration: 0.3)) { show = true }
                            Haptic.success()
                        }
                        .buttonStyle(DSButtonStyle())
                    }
                    .padding(16)

                    if show {
                        Color.black.opacity(0.3).transition(.opacity)
                        MockAlertBox(title: "결제가 완료됐어요", message: "주문하신 음료를 준비하고 있어요.", actions: [
                            AlertAction(title: "확인", bold: true) {
                                withAnimation(.spring(duration: 0.25)) { show = false; paid = true }
                            }
                        ])
                        .transition(.scale(scale: 1.15).combined(with: .opacity))
                    }
                }
            }
            DemoNote(text: "알럿의 버튼은 ‘확인’ 하나뿐이에요. 선택이 아니라 ‘읽었어요’라는 확인만 받아요.")
            NativeButton(title: "진짜 iOS 알럿 띄우기") { native = true }
        }
        .alert("결제가 완료됐어요", isPresented: $native) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("이게 iOS 기본 알럿이에요.")
        }
    }
}

// MARK: - 컨펌

struct ConfirmDemo: View {
    @State private var photos = Array(0..<6)
    @State private var target: Int? = nil
    @State private var note = "사진의 휴지통을 눌러보세요."
    @State private var native = false

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack {
                    VStack(alignment: .leading, spacing: 14) {
                        ScreenTitle(text: "앨범")
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)], spacing: 8) {
                            ForEach(photos, id: \.self) { p in
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Theme.pastel(p))
                                    .frame(height: 86)
                                    .overlay {
                                        Image(systemName: ["sun.max.fill", "leaf.fill", "drop.fill", "moon.fill", "cloud.fill", "flame.fill"][p % 6])
                                            .font(.system(size: 24)).foregroundStyle(Theme.deep(p))
                                    }
                                    .overlay(alignment: .topTrailing) {
                                        Button {
                                            withAnimation(.spring(duration: 0.3)) { target = p }
                                        } label: {
                                            Image(systemName: "trash.fill")
                                                .font(.system(size: 11, weight: .bold))
                                                .foregroundStyle(.white)
                                                .frame(width: 26, height: 26)
                                                .background(Color.black.opacity(0.35), in: Circle())
                                        }
                                        .padding(6)
                                    }
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(16)

                    if let t = target {
                        Color.black.opacity(0.3).transition(.opacity)
                        MockAlertBox(title: "이 사진을 삭제할까요?", message: "삭제한 사진은 되돌릴 수 없어요.", actions: [
                            AlertAction(title: "취소") {
                                withAnimation(.spring(duration: 0.25)) { target = nil }
                                note = "‘취소’를 골랐어요. 사진이 그대로 있어요."
                            },
                            AlertAction(title: "삭제", bold: true, destructive: true) {
                                withAnimation(.spring(duration: 0.3)) {
                                    photos.removeAll { $0 == t }
                                    target = nil
                                }
                                note = "‘삭제’를 골랐어요. 컨펌은 이렇게 두 가지 중 하나를 결정받아요."
                            },
                        ])
                        .transition(.scale(scale: 1.15).combined(with: .opacity))
                    }
                }
            }
            DemoNote(text: note)
            HStack(spacing: 8) {
                Button("사진 되살리기") { withAnimation { photos = Array(0..<6) } }
                    .buttonStyle(DSButtonStyle(kind: .ghost))
                NativeButton(title: "iOS 컨펌") { native = true }
            }
        }
        .alert("이 사진을 삭제할까요?", isPresented: $native) {
            Button("취소", role: .cancel) {}
            Button("삭제", role: .destructive) {}
        } message: {
            Text("iOS 기본 알럿에 버튼 두 개를 넣으면 컨펌이 돼요.")
        }
    }
}

// MARK: - 액션 시트

struct ActionSheetDemo: View {
    @State private var show = false
    @State private var native = false
    @State private var avatarColor = 1
    @State private var note = "‘프로필 사진 변경’을 눌러보세요."

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack(alignment: .bottom) {
                    VStack(spacing: 12) {
                        ScreenTitle(text: "내 정보")
                        Circle().fill(Theme.pastel(avatarColor))
                            .frame(width: 96, height: 96)
                            .overlay {
                                Image(systemName: avatarColor < 0 ? "person.fill" : "face.smiling.inverse")
                                    .font(.system(size: 44)).foregroundStyle(Theme.deep(avatarColor))
                            }
                            .padding(.top, 20)
                        Text("우디").font(.system(size: 18, weight: .bold)).foregroundStyle(Theme.text)
                        Button("프로필 사진 변경") {
                            withAnimation(.spring(duration: 0.35)) { show = true }
                        }
                        .buttonStyle(DSButtonStyle(kind: .secondary, compact: true))
                        Spacer()
                    }
                    .padding(16)
                    .frame(maxHeight: .infinity)

                    if show {
                        Color.black.opacity(0.35)
                            .onTapGesture { withAnimation(.spring(duration: 0.3)) { show = false } }
                            .transition(.opacity)
                        VStack(spacing: 8) {
                            VStack(spacing: 0) {
                                sheetButton("사진 찍기", divider: true) { pick(2, "‘사진 찍기’를 골랐어요.") }
                                sheetButton("앨범에서 선택", divider: true) { pick(4, "‘앨범에서 선택’을 골랐어요.") }
                                sheetButton("기본 이미지로 변경", destructive: true) { pick(-1, "기본 이미지로 바꿨어요.") }
                            }
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            Button {
                                withAnimation(.spring(duration: 0.3)) { show = false }
                                note = "‘취소’는 항상 맨 아래에 따로 떨어져 있어요."
                            } label: {
                                Text("취소").font(.system(size: 17, weight: .semibold)).foregroundStyle(Theme.blue)
                                    .frame(maxWidth: .infinity).frame(height: 50)
                                    .background(Theme.card, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(10)
                        .transition(.move(edge: .bottom))
                    }
                }
            }
            DemoNote(text: note)
            NativeButton(title: "iOS 기본 액션 시트") { native = true }
        }
        .confirmationDialog("프로필 사진", isPresented: $native, titleVisibility: .visible) {
            Button("사진 찍기") {}
            Button("앨범에서 선택") {}
            Button("기본 이미지로 변경", role: .destructive) {}
            Button("취소", role: .cancel) {}
        }
    }

    private func sheetButton(_ title: String, destructive: Bool = false, divider: Bool = false, action: @escaping () -> Void) -> some View {
        VStack(spacing: 0) {
            Button(action: action) {
                Text(title).font(.system(size: 17))
                    .foregroundStyle(destructive ? Theme.red : Theme.blue)
                    .frame(maxWidth: .infinity).frame(height: 50)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            if divider { Rectangle().fill(Theme.fillStrong).frame(height: 0.5) }
        }
    }

    private func pick(_ color: Int, _ message: String) {
        withAnimation(.spring(duration: 0.3)) {
            avatarColor = color
            show = false
        }
        note = message
    }
}

// MARK: - 토스트

struct ToastDemo: View {
    @State private var toast: String? = nil
    @State private var token = 0
    @State private var text = "오늘 배운 것: 토스트는 버튼이 없다!"
    @State private var count = 0

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            ScreenTitle(text: "메모")
                            Button("저장") { save() }
                                .buttonStyle(DSButtonStyle(kind: .primary, compact: true))
                        }
                        Text(text)
                            .font(.system(size: 15)).foregroundStyle(Theme.text)
                            .padding(14)
                            .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
                            .background(Theme.fill, in: RoundedRectangle(cornerRadius: 14))
                        Button {
                            UIPasteboard.general.string = text
                            showToast("복사했어요")
                        } label: {
                            Label("복사하기", systemImage: "doc.on.doc")
                        }
                        .buttonStyle(DSButtonStyle(kind: .ghost, compact: true))
                        Spacer()
                    }
                    .padding(16)

                    if let toast {
                        ToastPill(text: toast, icon: "checkmark.circle.fill")
                            .padding(.bottom, 30)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .id(token)
                    }
                }
            }
            DemoNote(text: count == 0 ? "‘저장’이나 ‘복사하기’를 눌러보세요." : "토스트는 2초 뒤 혼자 사라져요. 떠 있는 동안에도 다른 버튼을 계속 누를 수 있어요. (\(count)번 띄움)")
        }
    }

    private func save() { showToast("저장했어요") }

    private func showToast(_ message: String) {
        count += 1
        token += 1
        let current = token
        withAnimation(.spring(duration: 0.35)) { toast = message }
        delay(2.0) {
            if current == token { withAnimation(.easeOut(duration: 0.3)) { toast = nil } }
        }
    }
}

// MARK: - 스낵바

struct SnackbarDemo: View {
    struct Mail: Identifiable, Equatable { let id: Int; let from: String; let title: String }
    private static let all = [
        Mail(id: 0, from: "토스뱅크", title: "11월 이용 내역 안내"),
        Mail(id: 1, from: "디자인 팀", title: "다음 주 리뷰 일정"),
        Mail(id: 2, from: "쿠팡", title: "주문하신 상품이 출발했어요"),
        Mail(id: 3, from: "엄마", title: "주말에 밥 먹으러 와"),
        Mail(id: 4, from: "노션", title: "새 기능 소개"),
    ]
    @State private var mails = SnackbarDemo.all
    @State private var removed: (Mail, Int)? = nil
    @State private var token = 0
    @State private var note = "메일 오른쪽 휴지통을 눌러보세요."

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 12) {
                        ScreenTitle(text: "받은편지함")
                        ForEach(mails) { m in
                            HStack {
                                MockRow(index: m.id, title: m.from, subtitle: m.title, symbol: "envelope.fill")
                                Button { delete(m) } label: {
                                    Image(systemName: "trash").foregroundStyle(Theme.sub).frame(width: 32, height: 32)
                                }
                            }
                            .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
                        }
                        if mails.isEmpty {
                            Button("메일 되살리기") { withAnimation { mails = SnackbarDemo.all } }
                                .buttonStyle(DSButtonStyle(kind: .ghost, compact: true))
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(16)

                    if removed != nil {
                        HStack {
                            Text("메일을 삭제했어요").font(.system(size: 14, weight: .medium)).foregroundStyle(.white)
                            Spacer()
                            Button("되돌리기") { undo() }
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(Color(hex: 0x6AAAFF))
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 50)
                        .background(Theme.toast, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .padding(12)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            DemoNote(text: note)
        }
    }

    private func delete(_ m: Mail) {
        guard let idx = mails.firstIndex(of: m) else { return }
        withAnimation(.spring(duration: 0.35)) {
            mails.remove(at: idx)
            removed = (m, idx)
        }
        note = "아래 스낵바의 ‘되돌리기’를 4초 안에 눌러보세요."
        token += 1
        let current = token
        delay(4) {
            if current == token {
                withAnimation(.easeOut) { removed = nil }
                note = "스낵바가 사라졌어요. 이제는 되돌릴 수 없어요."
            }
        }
    }

    private func undo() {
        guard let r = removed else { return }
        let (m, idx) = r
        withAnimation(.spring(duration: 0.35)) {
            mails.insert(m, at: min(idx, mails.count))
            removed = nil
        }
        token += 1
        note = "되돌렸어요! 토스트와 달리 스낵바엔 이렇게 누를 수 있는 버튼이 있어요."
        Haptic.success()
    }
}

// MARK: - 툴팁

struct TooltipDemo: View {
    @State private var show = false
    @State private var token = 0

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 16) {
                    ScreenTitle(text: "급여 계산기")
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 4) {
                            Text("예상 수령액").font(.system(size: 14)).foregroundStyle(Theme.sub)
                            Button { toggle() } label: {
                                Image(systemName: "info.circle")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(show ? Theme.blue : Theme.faint)
                                    .frame(width: 28, height: 28)
                            }
                            .overlay(alignment: .top) {
                                if show {
                                    VStack(spacing: 0) {
                                        Text("세금 3.3%를 뺀 금액이에요")
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(.white)
                                            .fixedSize()
                                            .padding(.horizontal, 12).padding(.vertical, 9)
                                            .background(Theme.toast, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                                        Triangle().fill(Theme.toast).frame(width: 14, height: 7)
                                    }
                                    .alignmentGuide(.top) { d in d[.bottom] + 2 }
                                    .transition(.scale(scale: 0.8, anchor: .bottom).combined(with: .opacity))
                                }
                            }
                        }
                        Text("1,250,000원").font(.system(size: 28, weight: .bold)).foregroundStyle(Theme.text)
                    }
                    .padding(.top, 50)
                    .zIndex(1)
                    MockRow(index: 1, title: "세전 금액", subtitle: "1,292,657원", symbol: "wonsign.circle.fill")
                    MockRow(index: 5, title: "공제 금액", subtitle: "42,657원", symbol: "minus.circle.fill")
                    Spacer(minLength: 0)
                }
                .padding(16)
                .contentShape(Rectangle())
                .onTapGesture { withAnimation(.spring(duration: 0.25)) { show = false } }
            }
            DemoNote(text: show ? "툴팁 안에는 글만 있어요. 누를 버튼이 없죠? 다른 곳을 누르거나 3초 지나면 사라져요." : "‘예상 수령액’ 옆 ⓘ 아이콘을 눌러보세요.")
        }
    }

    private func toggle() {
        token += 1
        let current = token
        withAnimation(.spring(duration: 0.3)) { show.toggle() }
        delay(3) { if current == token { withAnimation { show = false } } }
    }
}

// MARK: - 팝오버

struct PopoverDemo: View {
    @State private var show = false
    @State private var big = false
    @State private var showPrice = true
    @State private var native = false

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(spacing: 12) {
                    HStack {
                        ScreenTitle(text: "관심 상품")
                        Button { withAnimation(.spring(duration: 0.3)) { show.toggle() } } label: {
                            IconTile(symbol: "slider.horizontal.3", tint: show ? Theme.blue : Theme.text)
                        }
                        .overlay(alignment: .bottomTrailing) {
                            if show {
                                popoverCard
                                    .alignmentGuide(.bottom) { d in d[.top] - 4 }
                                    .alignmentGuide(.trailing) { d in d[.trailing] - 6 }
                                    .transition(.scale(scale: 0.85, anchor: .topTrailing).combined(with: .opacity))
                            }
                        }
                    }
                    .zIndex(1)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: big ? 1 : 2), spacing: 8) {
                        ForEach(0..<4, id: \.self) { i in
                            VStack(alignment: .leading, spacing: 6) {
                                RoundedRectangle(cornerRadius: 12).fill(Theme.pastel(i)).frame(height: big ? 90 : 70)
                                    .overlay { Image(systemName: ["bag.fill", "headphones", "watch.analog", "camera.fill"][i]).font(.system(size: 22)).foregroundStyle(Theme.deep(i)) }
                                Text(["가방", "헤드폰", "시계", "카메라"][i]).font(.system(size: 13, weight: .semibold)).foregroundStyle(Theme.text)
                                if showPrice {
                                    Text(["39,000원", "129,000원", "89,000원", "459,000원"][i]).font(.system(size: 12)).foregroundStyle(Theme.sub)
                                }
                            }
                        }
                    }
                    .animation(.spring(duration: 0.35), value: big)
                    .animation(.spring(duration: 0.35), value: showPrice)
                    Spacer(minLength: 0)
                }
                .padding(16)
                .contentShape(Rectangle())
                .onTapGesture { withAnimation(.spring(duration: 0.25)) { show = false } }
            }
            DemoNote(text: show ? "팝오버 안의 스위치를 눌러보세요. 툴팁과 달리 직접 조작할 수 있어요." : "오른쪽 위 설정 아이콘을 눌러보세요.")
            Button { native = true } label: {
                Label("iOS 기본 팝오버", systemImage: "iphone.gen3")
            }
            .buttonStyle(DSButtonStyle(kind: .secondary))
            .popover(isPresented: $native, arrowEdge: .bottom) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("iOS 기본 팝오버").font(.headline)
                    Toggle("사진 크게 보기", isOn: $big)
                    Toggle("가격 보기", isOn: $showPrice)
                }
                .padding(20)
                .frame(width: 260)
                .presentationCompactAdaptation(.popover)
            }
        }
    }

    private var popoverCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("보기 설정").font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.sub)
            Toggle("사진 크게", isOn: $big).font(.system(size: 14))
            Toggle("가격 보기", isOn: $showPrice).font(.system(size: 14))
        }
        .tint(Theme.blue)
        .padding(14)
        .frame(width: 190)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(alignment: .topTrailing) {
            Triangle().fill(Theme.card).frame(width: 14, height: 7).rotationEffect(.degrees(180)).offset(x: -19, y: -6)
        }
        .shadow(color: .black.opacity(0.18), radius: 16, y: 6)
        .onTapGesture {}
    }
}

// MARK: - 바텀시트

struct BottomSheetDemo: View {
    @State private var show = false
    @State private var expanded = false
    @State private var drag: CGFloat = 0
    @State private var selected = 0
    @State private var native = false
    private let addresses = ["집 · 서울 마포구 월드컵로", "회사 · 서울 강남구 테헤란로", "본가 · 부산 해운대구 우동", "친구 · 대전 유성구 대학로", "새 배송지 추가"]

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 12) {
                        ScreenTitle(text: "주문서")
                        Text("배송지").font(.system(size: 13)).foregroundStyle(Theme.sub)
                        Button { open() } label: {
                            HStack {
                                Text(addresses[selected]).font(.system(size: 14, weight: .semibold)).foregroundStyle(Theme.text).lineLimit(1)
                                Spacer()
                                Image(systemName: "chevron.right").foregroundStyle(Theme.faint)
                            }
                            .padding(14)
                            .background(Theme.fill, in: RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PressStyle())
                        MockRow(index: 0, title: "무선 키보드", subtitle: "1개 · 59,000원", symbol: "keyboard.fill")
                        Spacer()
                        Button("배송지 선택") { open() }.buttonStyle(DSButtonStyle())
                    }
                    .padding(16)

                    if show {
                        Color.black.opacity(0.4)
                            .onTapGesture { close() }
                            .transition(.opacity)
                        sheet
                            .transition(.move(edge: .bottom))
                    }
                }
            }
            DemoNote(text: show ? "손잡이(회색 막대)를 위로 끌면 커지고, 아래로 끌면 닫혀요." : "‘배송지 선택’을 눌러 바텀시트를 열어보세요.")
            NativeButton(title: "iOS 기본 바텀시트") { native = true }
        }
        .sheet(isPresented: $native) {
            VStack(alignment: .leading, spacing: 16) {
                Text("iOS 기본 시트").font(.system(size: 20, weight: .bold))
                Text("위로 끌어 올리면 크게(large), 내리면 중간(medium) 또는 닫혀요.")
                    .foregroundStyle(Theme.sub)
                ForEach(0..<4, id: \.self) { i in
                    MockRow(index: i, title: addresses[i], subtitle: "배송지 \(i + 1)", symbol: "mappin.circle.fill")
                }
                Spacer()
            }
            .padding(24)
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(28)
        }
    }

    private var sheetHeight: CGFloat {
        let base: CGFloat = expanded ? 390 : 250
        return min(410, base - min(0, drag))
    }

    private var sheet: some View {
        VStack(alignment: .leading, spacing: 0) {
            Grabber().frame(maxWidth: .infinity).padding(.top, 8).padding(.bottom, 14)
            Text("배송지 선택").font(.system(size: 17, weight: .bold)).foregroundStyle(Theme.text).padding(.horizontal, 18).padding(.bottom, 8)
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(addresses.indices, id: \.self) { i in
                        Button {
                            if i < addresses.count - 1 { selected = i }
                            Haptic.selection()
                            close()
                        } label: {
                            HStack {
                                Text(addresses[i]).font(.system(size: 14)).foregroundStyle(i == addresses.count - 1 ? Theme.blue : Theme.text)
                                Spacer()
                                if i == selected { Image(systemName: "checkmark").foregroundStyle(Theme.blue) }
                            }
                            .padding(.horizontal, 18).frame(height: 48)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .scrollDisabled(!expanded)
        }
        .frame(maxWidth: .infinity)
        .frame(height: sheetHeight, alignment: .top)
        .background(Theme.card, in: SheetShape())
        .offset(y: max(0, drag))
        .gesture(
            DragGesture()
                .onChanged { v in drag = v.translation.height }
                .onEnded { v in
                    let t = v.translation.height
                    withAnimation(.spring(duration: 0.35)) {
                        if t > 90 {
                            if expanded && t < 220 { expanded = false } else { show = false; expanded = false }
                        } else if t < -60 {
                            expanded = true
                        }
                        drag = 0
                    }
                }
        )
    }

    private func open() { withAnimation(.spring(duration: 0.4)) { show = true } }
    private func close() { withAnimation(.spring(duration: 0.35)) { show = false; expanded = false } }
}

// MARK: - 드로어 (햄버거 아이콘과 공용)

struct DrawerPhone: View {
    var highlightIcon = false
    @State private var open = false
    @State private var page = "홈"
    @State private var drag: CGFloat = 0
    private let menus: [(String, String)] = [("홈", "house.fill"), ("주문 내역", "bag.fill"), ("쿠폰함", "ticket.fill"), ("설정", "gearshape.fill"), ("고객센터", "headphones")]

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 4) {
                            Button { setOpen(true) } label: {
                                IconTile(symbol: "line.3.horizontal", tint: highlightIcon ? Theme.blue : Theme.text)
                                    .background(highlightIcon ? Theme.blueSoft : Color.clear, in: RoundedRectangle(cornerRadius: 10))
                            }
                            Text(page).font(.system(size: 18, weight: .bold)).foregroundStyle(Theme.text)
                            Spacer()
                        }
                        ForEach(0..<4, id: \.self) { i in
                            MockRow(index: i + page.count, title: "\(page) 항목 \(i + 1)", subtitle: "내용 미리보기")
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(12)

                    if open {
                        Color.black.opacity(0.4)
                            .onTapGesture { setOpen(false) }
                            .transition(.opacity)
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 10) {
                                Circle().fill(Theme.blueSoft).frame(width: 40, height: 40)
                                    .overlay(Image(systemName: "person.fill").foregroundStyle(Theme.blue))
                                VStack(alignment: .leading) {
                                    Text("우디").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                                    Text("내 정보 보기").font(.system(size: 12)).foregroundStyle(Theme.sub)
                                }
                            }
                            .padding(.bottom, 14)
                            ForEach(menus.indices, id: \.self) { idx in
                                let m = menus[idx]
                                Button {
                                    page = m.0
                                    Haptic.selection()
                                    setOpen(false)
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: m.1).frame(width: 20)
                                        Text(m.0)
                                        Spacer()
                                    }
                                    .font(.system(size: 15, weight: page == m.0 ? .bold : .regular))
                                    .foregroundStyle(page == m.0 ? Theme.blue : Theme.text)
                                    .padding(.horizontal, 10).frame(height: 42)
                                    .background(page == m.0 ? Theme.blueSoft : Color.clear, in: RoundedRectangle(cornerRadius: 10))
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                            }
                            Spacer()
                        }
                        .padding(16)
                        .frame(width: 200)
                        .frame(maxHeight: .infinity)
                        .background(Theme.card)
                        .offset(x: min(0, drag))
                        .gesture(DragGesture().onChanged { drag = $0.translation.width }.onEnded { v in
                            if v.translation.width < -60 { setOpen(false) }
                            withAnimation(.spring(duration: 0.3)) { drag = 0 }
                        })
                        .transition(.move(edge: .leading))
                    }
                }
            }
            DemoNote(text: open ? "메뉴를 고르거나, 패널을 왼쪽으로 밀거나, 어두운 곳을 눌러 닫아보세요." : "왼쪽 위 ≡ 아이콘을 눌러보세요.")
        }
    }

    private func setOpen(_ value: Bool) {
        withAnimation(.spring(duration: 0.35)) { open = value }
    }
}

// MARK: - 배너

struct BannerDemo: View {
    @State private var showBanner = true
    @State private var toast: String? = nil

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 12) {
                        ScreenTitle(text: "홈")
                        if showBanner {
                            HStack(spacing: 10) {
                                Text("🌙").font(.system(size: 24))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("다크 모드가 나왔어요").font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
                                    Button("보러가기 ›") { flash("다크 모드 소개 화면으로 이동해요") }
                                        .font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.blue)
                                }
                                Spacer()
                                Button { withAnimation(.spring(duration: 0.35)) { showBanner = false } } label: {
                                    Image(systemName: "xmark").font(.system(size: 12, weight: .bold)).foregroundStyle(Theme.sub)
                                        .frame(width: 28, height: 28)
                                }
                            }
                            .padding(12)
                            .background(Theme.blueSoft, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                        ForEach(0..<3, id: \.self) { i in
                            MockRow(index: i + 2, title: ["오늘의 할 일", "읽지 않은 글", "추천 콘텐츠"][i], subtitle: "탭해서 보기", symbol: ["checklist", "doc.text.fill", "sparkles"][i])
                        }
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("AD").font(.system(size: 10, weight: .bold)).foregroundStyle(.white.opacity(0.8))
                                Text("첫 구매 3,000원 할인").font(.system(size: 14, weight: .bold)).foregroundStyle(.white)
                            }
                            Spacer()
                            Image(systemName: "gift.fill").font(.system(size: 28)).foregroundStyle(.white)
                        }
                        .padding(14)
                        .background(LinearGradient(colors: [Color(hex: 0xFF8A5B), Color(hex: 0xF04452)], startPoint: .leading, endPoint: .trailing), in: RoundedRectangle(cornerRadius: 14))
                        .onTapGesture { flash("광고 배너를 눌렀어요") }
                        Spacer(minLength: 0)
                    }
                    .padding(16)

                    if let toast {
                        ToastPill(text: toast).padding(.bottom, 24).transition(.opacity)
                    }
                }
            }
            DemoNote(text: showBanner ? "배너는 앱 화면 ‘안’에 자리를 차지해요. 저절로 사라지지 않아요." : "닫으면 아래 콘텐츠가 위로 올라와 자리를 채워요.")
            if !showBanner {
                Button("배너 다시 보기") { withAnimation(.spring(duration: 0.35)) { showBanner = true } }
                    .buttonStyle(DSButtonStyle(kind: .ghost))
            }
        }
    }

    private func flash(_ text: String) {
        withAnimation { toast = text }
        delay(1.6) { withAnimation { toast = nil } }
    }
}

// MARK: - 푸시 알림

struct PushDemo: View {
    @State private var arrived = false
    @State private var opened = false
    @State private var realState: String? = nil

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame(dark: !opened) {
                ZStack(alignment: .top) {
                    if opened {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Button { withAnimation(.spring(duration: 0.4)) { opened = false; arrived = false } } label: {
                                    Image(systemName: "chevron.left").font(.system(size: 18, weight: .semibold)).foregroundStyle(Theme.text)
                                }
                                Text("배송 조회").font(.system(size: 17, weight: .bold)).foregroundStyle(Theme.text)
                            }
                            Image(systemName: "shippingbox.fill").font(.system(size: 50)).foregroundStyle(Theme.orange)
                                .frame(maxWidth: .infinity).padding(.vertical, 20)
                            Text("문 앞에 놓고 갔어요").font(.system(size: 20, weight: .bold)).foregroundStyle(Theme.text)
                            Text("알림을 눌러서 앱이 열렸어요.\n푸시는 앱 ‘밖’에서 앱으로 들어오는 문이에요.").font(.system(size: 14)).foregroundStyle(Theme.sub)
                            Spacer()
                        }
                        .padding(16)
                        .transition(.opacity)
                    } else {
                        ZStack(alignment: .top) {
                            LinearGradient(colors: [Color(hex: 0x2B3A67), Color(hex: 0x6A4C93)], startPoint: .top, endPoint: .bottom)
                            VStack(spacing: 2) {
                                Image(systemName: "lock.fill").font(.system(size: 14)).foregroundStyle(.white.opacity(0.8))
                                Text("11월 19일 목요일").font(.system(size: 14, weight: .semibold)).foregroundStyle(.white.opacity(0.85)).padding(.top, 6)
                                Text("9:41").font(.system(size: 64, weight: .bold, design: .rounded)).foregroundStyle(.white)
                            }
                            .padding(.top, 10)

                            if arrived {
                                Button { withAnimation(.spring(duration: 0.45)) { opened = true } } label: {
                                    HStack(alignment: .top, spacing: 10) {
                                        RoundedRectangle(cornerRadius: 8).fill(Theme.blue).frame(width: 34, height: 34)
                                            .overlay(Image(systemName: "shippingbox.fill").font(.system(size: 15)).foregroundStyle(.white))
                                        VStack(alignment: .leading, spacing: 2) {
                                            HStack {
                                                Text("UI 도감").font(.system(size: 13, weight: .semibold))
                                                Spacer()
                                                Text("지금").font(.system(size: 12)).opacity(0.6)
                                            }
                                            Text("택배가 도착했어요 📦").font(.system(size: 14, weight: .semibold))
                                            Text("문 앞에 놓고 갔어요. 눌러서 확인하세요.").font(.system(size: 13)).opacity(0.8)
                                        }
                                    }
                                    .foregroundStyle(Theme.text)
                                    .padding(12)
                                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                                }
                                .buttonStyle(PressStyle())
                                .padding(.horizontal, 10)
                                .padding(.top, 150)
                                .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }
                        .transition(.opacity)
                    }
                }
            }
            HStack(spacing: 8) {
                Button("푸시 보내기") {
                    opened = false
                    withAnimation(.spring(duration: 0.5, bounce: 0.3)) { arrived = true }
                    Haptic.impact(.medium)
                }
                .buttonStyle(DSButtonStyle())
                Button("초기화") { withAnimation { arrived = false; opened = false } }
                    .buttonStyle(DSButtonStyle(kind: .ghost))
                    .frame(width: 90)
            }
            DemoNote(text: realState ?? "앱이 꺼져 있어도 잠금 화면에 도착하는 게 푸시예요. 알림을 눌러보세요.")
            Button {
                NotificationManager.shared.schedule(after: 5, title: "UI 도감", body: "이게 진짜 푸시 알림이에요! 👋 앱 밖에서도 도착해요.") { ok in
                    realState = ok ? "5초 뒤에 진짜 알림이 와요. 홈 화면으로 나가서 기다려 보세요!" : "알림 권한이 꺼져 있어요. 설정 > 알림에서 허용해주세요."
                }
            } label: {
                Label("진짜 푸시 받아보기 (5초 뒤)", systemImage: "iphone.gen3.radiowaves.left.and.right")
            }
            .buttonStyle(DSButtonStyle(kind: .secondary))
        }
    }
}

// MARK: - 컨텍스트 메뉴

struct ContextMenuDemo: View {
    @State private var note = "사진 하나를 꾹 길게 눌러보세요."
    @State private var favorites: Set<Int> = []
    @State private var hidden: Set<Int> = []

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 12) {
                    ScreenTitle(text: "사진")
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)], spacing: 8) {
                        ForEach(0..<6, id: \.self) { i in
                            if !hidden.contains(i) {
                                photo(i)
                                    .contextMenu {
                                        Button { note = "‘복사’를 골랐어요." } label: { Label("복사", systemImage: "doc.on.doc") }
                                        Button {
                                            if favorites.contains(i) { favorites.remove(i) } else { favorites.insert(i) }
                                            note = "즐겨찾기를 바꿨어요."
                                        } label: { Label(favorites.contains(i) ? "즐겨찾기 해제" : "즐겨찾기", systemImage: "heart") }
                                        Button { note = "‘공유’를 골랐어요." } label: { Label("공유", systemImage: "square.and.arrow.up") }
                                        Button(role: .destructive) {
                                            withAnimation { _ = hidden.insert(i) }
                                            note = "사진을 삭제했어요."
                                        } label: { Label("삭제", systemImage: "trash") }
                                    } preview: {
                                        photo(i).frame(width: 260, height: 260)
                                    }
                            }
                        }
                    }
                    Spacer(minLength: 0)
                }
                .padding(16)
            }
            DemoNote(text: note)
            if !hidden.isEmpty {
                Button("사진 되살리기") { withAnimation { hidden = [] } }.buttonStyle(DSButtonStyle(kind: .ghost))
            }
        }
    }

    private func photo(_ i: Int) -> some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .fill(Theme.pastel(i))
            .frame(height: 96)
            .overlay {
                Image(systemName: ["mountain.2.fill", "tree.fill", "sailboat.fill", "fish.fill", "bird.fill", "camera.macro"][i])
                    .font(.system(size: 28)).foregroundStyle(Theme.deep(i))
            }
            .overlay(alignment: .bottomTrailing) {
                if favorites.contains(i) {
                    Image(systemName: "heart.fill").foregroundStyle(Theme.red).padding(8)
                }
            }
    }
}

// MARK: - 딤

struct DimDemo: View {
    @State private var on = true
    @State private var opacity: Double = 0.45

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack {
                    ColorfulContent()
                    if on {
                        Color.black.opacity(opacity).transition(.opacity)
                        VStack(spacing: 6) {
                            Text("딤 위에 뜬 창").font(.system(size: 16, weight: .bold)).foregroundStyle(Theme.text)
                            Text("뒤 내용은 보이지만\n어두워서 여기에 집중돼요").font(.system(size: 13)).foregroundStyle(Theme.sub).multilineTextAlignment(.center)
                        }
                        .padding(20)
                        .background(Theme.card, in: RoundedRectangle(cornerRadius: 20))
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            VStack(spacing: 12) {
                Toggle("딤 켜기", isOn: $on.animation(.easeInOut(duration: 0.25)))
                    .font(.system(size: 15, weight: .semibold)).tint(Theme.blue)
                HStack {
                    Text("어두운 정도").font(.system(size: 14)).foregroundStyle(Theme.sub)
                    Slider(value: $opacity, in: 0...0.85).tint(Theme.blue)
                    Text("\(Int(opacity * 100))%").font(.system(size: 14, weight: .semibold)).monospacedDigit().frame(width: 44)
                }
                .disabled(!on)
            }
            .padding(16)
            .background(Theme.fill, in: RoundedRectangle(cornerRadius: 16))
            DemoNote(text: "딤은 ‘검정색 반투명 막’이에요. 뒤 글씨는 또렷하게 그대로 보여요.")
        }
    }
}

// MARK: - 블러

struct BlurDemo: View {
    @State private var on = true
    @State private var radius: Double = 8
    @State private var material = false

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack {
                    ColorfulContent()
                        .blur(radius: (on && !material) ? radius : 0)
                    if on && material {
                        Rectangle().fill(.ultraThinMaterial).transition(.opacity)
                    }
                    if on {
                        VStack(spacing: 6) {
                            Text("블러 위에 뜬 창").font(.system(size: 16, weight: .bold)).foregroundStyle(Theme.text)
                            Text("뒤 내용이 뿌옇게 흐려져서\n읽을 수 없어요").font(.system(size: 13)).foregroundStyle(Theme.sub).multilineTextAlignment(.center)
                        }
                        .padding(20)
                        .background(Theme.card, in: RoundedRectangle(cornerRadius: 20))
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: on)
                .animation(.easeInOut(duration: 0.3), value: material)
            }
            VStack(spacing: 12) {
                Toggle("블러 켜기", isOn: $on).font(.system(size: 15, weight: .semibold)).tint(Theme.blue)
                Toggle("유리 효과 (iOS 머티리얼)", isOn: $material).font(.system(size: 15, weight: .semibold)).tint(Theme.blue)
                HStack {
                    Text("흐림 정도").font(.system(size: 14)).foregroundStyle(Theme.sub)
                    Slider(value: $radius, in: 0...20).tint(Theme.blue)
                    Text("\(Int(radius))").font(.system(size: 14, weight: .semibold)).monospacedDigit().frame(width: 30)
                }
                .disabled(!on || material)
            }
            .padding(16)
            .background(Theme.fill, in: RoundedRectangle(cornerRadius: 16))
            DemoNote(text: "블러는 어둡게가 아니라 ‘흐리게’예요. 딤 데모와 비교해 보세요.")
        }
    }
}
