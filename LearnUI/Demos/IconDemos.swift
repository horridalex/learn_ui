import SwiftUI
import UIKit
import UniformTypeIdentifiers

/// 아이콘 데모 위에 ‘이 아이콘이에요’를 보여주는 헤더
struct IconSpotlight: View {
    let concept: Concept
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: concept.symbol)
                .font(.system(size: 24, weight: .semibold))
                .rotationEffect(.degrees(concept.rotation))
                .foregroundStyle(Theme.text)
                .frame(width: 56, height: 56)
                .background(Theme.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
            VStack(alignment: .leading, spacing: 2) {
                Text(concept.ko).font(.system(size: 17, weight: .bold)).foregroundStyle(Theme.text)
                Text(concept.summary).font(.system(size: 13)).foregroundStyle(Theme.sub).lineLimit(2)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(Theme.fill, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

// MARK: - 케밥

struct KebabDemo: View {
    @State private var comments = [("민지", "와 이거 진짜 유용하네요!"), ("준호", "토스트랑 스낵바 이제 안 헷갈려요"), ("서연", "북마크 해둘게요 📌"), ("하늘", "2탄도 기대할게요")]
    @State private var note = "댓글 오른쪽의 ⋮ 를 눌러보세요."

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 4) {
                    ScreenTitle(text: "댓글 \(comments.count)").padding(.bottom, 8)
                    ForEach(comments.indices, id: \.self) { i in
                        HStack(alignment: .top, spacing: 10) {
                            Circle().fill(Theme.pastel(i)).frame(width: 34, height: 34)
                                .overlay(Text(String(comments[i].0.prefix(1))).font(.system(size: 13, weight: .bold)).foregroundStyle(Theme.deep(i)))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(comments[i].0).font(.system(size: 13, weight: .bold)).foregroundStyle(Theme.text)
                                Text(comments[i].1).font(.system(size: 13)).foregroundStyle(Theme.text)
                            }
                            Spacer()
                            Menu {
                                Button { note = "‘\(comments[i].0)’ 댓글 수정을 골랐어요. 케밥 메뉴는 ‘이 댓글 하나’에 대한 메뉴예요." } label: { Label("수정", systemImage: "pencil") }
                                Button { note = "신고했어요." } label: { Label("신고", systemImage: "exclamationmark.bubble") }
                                Button(role: .destructive) {
                                    let name = comments[i].0
                                    withAnimation { _ = comments.remove(at: i) }
                                    note = "‘\(name)’ 댓글을 삭제했어요."
                                } label: { Label("삭제", systemImage: "trash") }
                            } label: {
                                IconTile(symbol: "ellipsis", rotation: 90, size: 15, tint: Theme.sub)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    if comments.isEmpty {
                        Button("댓글 되살리기") {
                            withAnimation { comments = [("민지", "와 이거 진짜 유용하네요!"), ("준호", "토스트랑 스낵바 이제 안 헷갈려요"), ("서연", "북마크 해둘게요 📌"), ("하늘", "2탄도 기대할게요")] }
                        }
                        .buttonStyle(DSButtonStyle(kind: .ghost, compact: true))
                    }
                    Spacer(minLength: 0)
                }
                .padding(16)
            }
            DemoNote(text: note)
        }
    }
}

// MARK: - 미트볼

struct MeatballsDemo: View {
    @State private var hidden = false
    @State private var saved = false
    @State private var note = "게시물 오른쪽 위 ••• 를 눌러보세요."

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 10) {
                    if hidden {
                        VStack(spacing: 10) {
                            Image(systemName: "eye.slash").font(.system(size: 30)).foregroundStyle(Theme.faint)
                            Text("게시물을 숨겼어요").font(.system(size: 15, weight: .semibold)).foregroundStyle(Theme.text)
                            Button("되돌리기") { withAnimation { hidden = false } }
                                .buttonStyle(DSButtonStyle(kind: .secondary, compact: true))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        HStack(spacing: 10) {
                            Circle().fill(LinearGradient(colors: [Color(hex: 0xFFB800), Color(hex: 0xF04452)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 34, height: 34)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("travel_woody").font(.system(size: 13, weight: .bold)).foregroundStyle(Theme.text)
                                Text("제주도").font(.system(size: 11)).foregroundStyle(Theme.sub)
                            }
                            Spacer()
                            Menu {
                                Button { note = "링크를 복사했어요." } label: { Label("링크 복사", systemImage: "link") }
                                Button { saved.toggle(); note = saved ? "저장했어요." : "저장을 취소했어요." } label: { Label(saved ? "저장 취소" : "저장", systemImage: "bookmark") }
                                Button { withAnimation { hidden = true }; note = "게시물을 숨겼어요." } label: { Label("숨기기", systemImage: "eye.slash") }
                                Button(role: .destructive) { note = "신고했어요." } label: { Label("신고", systemImage: "exclamationmark.triangle") }
                            } label: {
                                IconTile(symbol: "ellipsis", size: 17, tint: Theme.text)
                            }
                        }
                        .padding(.horizontal, 12)
                        RoundedRectangle(cornerRadius: 0)
                            .fill(LinearGradient(colors: [Color(hex: 0x5AA9FF), Color(hex: 0x15C47E)], startPoint: .top, endPoint: .bottom))
                            .frame(height: 230)
                            .overlay(Image(systemName: "sun.horizon.fill").font(.system(size: 60)).foregroundStyle(.white))
                        HStack(spacing: 14) {
                            Image(systemName: "heart")
                            Image(systemName: "bubble.right")
                            Image(systemName: "paperplane")
                            Spacer()
                            Image(systemName: saved ? "bookmark.fill" : "bookmark")
                        }
                        .font(.system(size: 20)).foregroundStyle(Theme.text)
                        .padding(.horizontal, 12)
                        Spacer(minLength: 0)
                    }
                }
                .padding(.top, 6)
            }
            DemoNote(text: note)
        }
    }
}

// MARK: - 하트

struct HeartDemo: View {
    @State private var liked = false
    @State private var count = 129
    @State private var burst = false

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(LinearGradient(colors: [Color(hex: 0xFFB3C7), Color(hex: 0xFF8A5B)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .overlay(Text("🐶").font(.system(size: 90)))
                        if burst {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 90)).foregroundStyle(.white)
                                .shadow(color: .black.opacity(0.2), radius: 10)
                                .transition(.scale(scale: 0.3).combined(with: .opacity))
                        }
                    }
                    .frame(height: 270)
                    .onTapGesture(count: 2) { doubleTap() }
                    HStack(spacing: 14) {
                        Button { toggle() } label: {
                            Image(systemName: liked ? "heart.fill" : "heart")
                                .font(.system(size: 24))
                                .foregroundStyle(liked ? Theme.red : Theme.text)
                                .symbolEffect(.bounce, value: liked)
                        }
                        Image(systemName: "bubble.right").font(.system(size: 22)).foregroundStyle(Theme.text)
                        Spacer()
                        Image(systemName: "bookmark").font(.system(size: 22)).foregroundStyle(Theme.faint)
                    }
                    .padding(.horizontal, 14)
                    Text("좋아요 \(count)개").font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
                        .contentTransition(.numericText())
                        .padding(.horizontal, 14)
                    Text("다른 사람들도 이 숫자를 볼 수 있어요").font(.system(size: 12)).foregroundStyle(Theme.sub).padding(.horizontal, 14)
                    Spacer(minLength: 0)
                }
                .padding(.top, 6)
            }
            DemoNote(text: liked ? "좋아요를 눌렀어요. 하트는 ‘마음에 들어요’라는 공개적인 반응이에요." : "하트를 누르거나, 사진을 두 번 톡톡 눌러보세요.")
        }
    }

    private func toggle() {
        withAnimation(.spring(duration: 0.3)) {
            liked.toggle()
            count += liked ? 1 : -1
        }
        Haptic.impact(.light)
    }

    private func doubleTap() {
        if !liked { toggle() }
        withAnimation(.spring(duration: 0.3, bounce: 0.5)) { burst = true }
        delay(0.7) { withAnimation(.easeOut(duration: 0.25)) { burst = false } }
    }
}

// MARK: - 북마크

struct BookmarkDemo: View {
    @State private var saved: Set<Int> = []
    @State private var tab = 0
    @State private var toast: String? = nil
    private let articles = ["초보자를 위한 iOS 디자인", "다크 모드 색 고르는 법", "버튼 문구 잘 쓰는 법", "모달 대신 시트를 쓰는 이유", "아이콘 크기 가이드"]

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 12) {
                        ScreenTitle(text: "아티클")
                        Picker("", selection: $tab) {
                            Text("전체").tag(0)
                            Text("저장함 \(saved.count)").tag(1)
                        }
                        .pickerStyle(.segmented)
                        let list = tab == 0 ? Array(articles.indices) : articles.indices.filter { saved.contains($0) }
                        if list.isEmpty {
                            Text("저장한 글이 없어요.\n책갈피를 눌러 저장해보세요.").font(.system(size: 13)).foregroundStyle(Theme.sub)
                                .multilineTextAlignment(.center).frame(maxWidth: .infinity).padding(.top, 40)
                        }
                        ForEach(list, id: \.self) { i in
                            HStack {
                                MockRow(index: i, title: articles[i], subtitle: "5분 읽기", symbol: "doc.richtext.fill")
                                Button { toggle(i) } label: {
                                    Image(systemName: saved.contains(i) ? "bookmark.fill" : "bookmark")
                                        .font(.system(size: 18))
                                        .foregroundStyle(saved.contains(i) ? Theme.blue : Theme.sub)
                                        .symbolEffect(.bounce, value: saved.contains(i))
                                        .frame(width: 34, height: 34)
                                }
                            }
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(16)
                    .animation(.spring(duration: 0.3), value: tab)

                    if let toast {
                        ToastPill(text: toast, icon: "bookmark.fill").padding(.bottom, 24).transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            DemoNote(text: "북마크는 ‘나중에 다시 볼래’예요. 저장한 글은 ‘저장함’에 나만 볼 수 있게 모여요.")
        }
    }

    private func toggle(_ i: Int) {
        withAnimation(.spring(duration: 0.3)) {
            if saved.contains(i) { saved.remove(i) } else { saved.insert(i) }
        }
        let text = saved.contains(i) ? "저장함에 담았어요" : "저장을 취소했어요"
        withAnimation { toast = text }
        delay(1.4) { if toast == text { withAnimation { toast = nil } } }
        Haptic.tap()
    }
}

// MARK: - 공유

struct ShareDemo: View {
    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        ScreenTitle(text: "오늘의 글")
                        ShareLink(item: "UI 도감에서 ‘공유 vs 내보내기’ 차이를 배웠어요! 공유는 사람에게 보내기, 내보내기는 파일로 꺼내기 👀") {
                            IconTile(symbol: "point.3.connected.trianglepath.dotted", tint: Theme.blue)
                        }
                    }
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(colors: [Color(hex: 0x8B5CF6), Color(hex: 0x3182F6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(height: 150)
                        .overlay(Text("공유와 내보내기는\n다르다").font(.system(size: 20, weight: .heavy)).foregroundStyle(.white).multilineTextAlignment(.center))
                    Text("공유 아이콘을 누르면 iOS 공유 시트가 열려요. 카톡·메시지·메일 등 ‘누구에게’ 보낼지를 고르죠.")
                        .font(.system(size: 13)).foregroundStyle(Theme.sub)
                    Spacer()
                    ShareLink(item: URL(string: "https://www.apple.com/kr/ios/")!, subject: Text("UI 도감"), message: Text("이 링크 봐봐!")) {
                        Label("링크 공유하기", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(DSButtonStyle())
                }
                .padding(16)
            }
            DemoNote(text: "아이콘 모양은 앱마다 달라요. 안드로이드는 점 세 개 연결(⋰), iOS는 네모 위 화살표(□↑)를 공유로 써요.")
        }
    }
}

// MARK: - 내보내기

struct TextFile: FileDocument {
    static var readableContentTypes: [UTType] { [.plainText] }
    var text: String
    init(text: String) { self.text = text }
    init(configuration: ReadConfiguration) throws {
        text = String(decoding: configuration.file.regularFileContents ?? Data(), as: UTF8.self)
    }
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: Data(text.utf8))
    }
}

struct ExportDemo: View {
    @State private var sheet = false
    @State private var progress: Double? = nil
    @State private var result: String? = nil
    @State private var exporting = false
    @State private var note = "오른쪽 위 내보내기 아이콘을 눌러보세요."
    private let formats = [("PDF 문서", "doc.richtext", "가계부_11월.pdf"), ("엑셀 (CSV)", "tablecells", "가계부_11월.csv"), ("이미지 (PNG)", "photo", "가계부_11월.png")]
    private let memo = "11월 가계부\n- 커피 4,500원\n- 점심 9,000원\n- 택시 12,300원\n합계 25,800원"

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            ScreenTitle(text: "가계부")
                            Button { withAnimation(.spring(duration: 0.35)) { sheet = true } } label: {
                                IconTile(symbol: "square.and.arrow.up", tint: Theme.blue)
                            }
                        }
                        Text(memo).font(.system(size: 14, design: .monospaced)).foregroundStyle(Theme.text)
                            .padding(14).frame(maxWidth: .infinity, alignment: .leading)
                            .background(Theme.fill, in: RoundedRectangle(cornerRadius: 14))
                        if let p = progress {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("파일 만드는 중…").font(.system(size: 12)).foregroundStyle(Theme.sub)
                                ProgressView(value: p).tint(Theme.blue)
                            }
                        }
                        if let result {
                            HStack(spacing: 10) {
                                Image(systemName: "doc.fill").font(.system(size: 26)).foregroundStyle(Theme.blue)
                                VStack(alignment: .leading) {
                                    Text(result).font(.system(size: 14, weight: .semibold)).foregroundStyle(Theme.text)
                                    Text("파일로 저장됐어요").font(.system(size: 12)).foregroundStyle(Theme.sub)
                                }
                            }
                            .padding(12).frame(maxWidth: .infinity, alignment: .leading)
                            .background(Theme.blueSoft, in: RoundedRectangle(cornerRadius: 14))
                            .transition(.scale.combined(with: .opacity))
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(16)

                    if sheet {
                        Color.black.opacity(0.35).onTapGesture { withAnimation { sheet = false } }.transition(.opacity)
                        VStack(alignment: .leading, spacing: 0) {
                            Grabber().frame(maxWidth: .infinity).padding(.vertical, 8)
                            Text("어떤 형식으로 내보낼까요?").font(.system(size: 16, weight: .bold)).foregroundStyle(Theme.text).padding(.horizontal, 18).padding(.bottom, 8)
                            ForEach(formats.indices, id: \.self) { idx in
                                let f = formats[idx]
                                Button { export(f.2) } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: f.1).frame(width: 24).foregroundStyle(Theme.blue)
                                        Text(f.0).foregroundStyle(Theme.text)
                                        Spacer()
                                    }
                                    .font(.system(size: 15))
                                    .padding(.horizontal, 18).frame(height: 48)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.bottom, 16)
                        .background(Theme.card, in: SheetShape())
                        .transition(.move(edge: .bottom))
                    }
                }
            }
            DemoNote(text: note)
            Button {
                exporting = true
            } label: {
                Label("텍스트 파일로 진짜 내보내기", systemImage: "iphone.gen3")
            }
            .buttonStyle(DSButtonStyle(kind: .secondary))
        }
        .fileExporter(isPresented: $exporting, document: TextFile(text: memo), contentType: .plainText, defaultFilename: "가계부_11월") { r in
            switch r {
            case .success: note = "파일 앱에 ‘가계부_11월.txt’로 저장됐어요! 이게 진짜 내보내기예요."
            case .failure: note = "내보내기를 취소했어요."
            }
        }
    }

    private func export(_ name: String) {
        withAnimation(.spring(duration: 0.3)) { sheet = false; result = nil; progress = 0 }
        note = "공유처럼 ‘누구에게’가 아니라, ‘어떤 형식의 파일’로 만들지를 골랐어요."
        Task { @MainActor in
            for i in 1...10 {
                try? await Task.sleep(nanoseconds: 90_000_000)
                withAnimation { progress = Double(i) / 10 }
            }
            withAnimation(.spring(duration: 0.35)) { progress = nil; result = name }
            Haptic.success()
        }
    }
}

// MARK: - 닫기

struct CloseDemo: View {
    @State private var open = false
    @State private var step = 1
    @State private var note = "‘글쓰기’를 눌러 모달을 열고 2단계까지 간 뒤 X를 눌러보세요."

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack {
                    VStack(alignment: .leading, spacing: 12) {
                        ScreenTitle(text: "커뮤니티")
                        ForEach(0..<3, id: \.self) { i in MockRow(index: i, title: "게시글 \(i + 1)", subtitle: "원래 화면") }
                        Spacer()
                        Button("글쓰기") {
                            step = 1
                            withAnimation(.spring(duration: 0.4)) { open = true }
                        }
                        .buttonStyle(DSButtonStyle())
                    }
                    .padding(16)

                    if open {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                if step == 2 {
                                    Button { withAnimation(.spring(duration: 0.35)) { step = 1 }; note = "‹ 는 한 단계(1단계)로만 돌아가요. 모달은 그대로예요." } label: {
                                        IconTile(symbol: "chevron.left", size: 18)
                                    }
                                } else {
                                    Color.clear.frame(width: 40, height: 40)
                                }
                                Spacer()
                                Text("새 글 \(step)/2").font(.system(size: 16, weight: .bold)).foregroundStyle(Theme.text)
                                Spacer()
                                Button {
                                    withAnimation(.spring(duration: 0.4)) { open = false }
                                    note = step == 2 ? "2단계였지만 X를 누르니 1단계를 거치지 않고 흐름 전체가 닫혔어요!" : "X를 누르니 모달이 아래로 사라졌어요."
                                    Haptic.tap()
                                } label: {
                                    IconTile(symbol: "xmark", size: 17)
                                        .background(Theme.redSoft, in: Circle())
                                }
                            }
                            .padding(.horizontal, 10).padding(.vertical, 6)
                            VStack(alignment: .leading, spacing: 12) {
                                Text(step == 1 ? "1단계: 카테고리 고르기" : "2단계: 내용 쓰기").font(.system(size: 18, weight: .bold)).foregroundStyle(Theme.text)
                                if step == 1 {
                                    ForEach(["자유", "질문", "정보"], id: \.self) { c in
                                        Text(c).font(.system(size: 15)).padding(14).frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Theme.fill, in: RoundedRectangle(cornerRadius: 12))
                                    }
                                } else {
                                    RoundedRectangle(cornerRadius: 12).fill(Theme.fill).frame(height: 140)
                                        .overlay(alignment: .topLeading) { Text("내용을 입력하세요").foregroundStyle(Theme.faint).padding(14) }
                                }
                                Spacer()
                                if step == 1 {
                                    Button("다음") { withAnimation(.spring(duration: 0.35)) { step = 2 }; note = "이제 X를 눌러보세요. 몇 단계든 한 번에 닫혀요." }
                                        .buttonStyle(DSButtonStyle())
                                }
                            }
                            .padding(16)
                        }
                        .background(Theme.card)
                        .transition(.move(edge: .bottom))
                    }
                }
            }
            DemoNote(text: note)
        }
    }
}

// MARK: - 뒤로

struct BackDemo: View {
    @State private var stack: [String] = ["카테고리"]
    private let next = ["카테고리": "상품", "상품": "리뷰", "리뷰": "리뷰 상세"]

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack {
                    ForEach(stack.indices, id: \.self) { i in
                        screen(stack[i], depth: i)
                            .zIndex(Double(i))
                            .transition(.move(edge: .trailing))
                    }
                }
                .clipped()
            }
            HStack(spacing: 4) {
                ForEach(stack.indices, id: \.self) { i in
                    if i > 0 { Image(systemName: "chevron.right").font(.system(size: 10)).foregroundStyle(Theme.faint) }
                    Text(stack[i]).font(.system(size: 13, weight: i == stack.count - 1 ? .bold : .regular))
                        .foregroundStyle(i == stack.count - 1 ? Theme.blue : Theme.sub)
                }
            }
            DemoNote(text: stack.count == 1 ? "항목을 눌러 두 단계 이상 들어가 보세요." : "‹ 를 누르면 딱 한 칸(\(stack[stack.count - 2]))으로만 돌아가요.")
        }
    }

    private func screen(_ title: String, depth: Int) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                if depth > 0 {
                    Button {
                        withAnimation(.spring(duration: 0.4)) { _ = stack.popLast() }
                        Haptic.tap()
                    } label: {
                        IconTile(symbol: "chevron.left", size: 18).background(Theme.blueSoft, in: Circle())
                    }
                } else {
                    Color.clear.frame(width: 40, height: 40)
                }
                Spacer()
                Text(title).font(.system(size: 16, weight: .bold)).foregroundStyle(Theme.text)
                Spacer()
                Color.clear.frame(width: 40, height: 40)
            }
            .padding(.horizontal, 10).padding(.vertical, 4)
            VStack(spacing: 10) {
                if let n = next[title] {
                    ForEach(0..<4, id: \.self) { i in
                        Button {
                            withAnimation(.spring(duration: 0.4)) { stack.append(n) }
                        } label: {
                            HStack {
                                MockRow(index: i + depth, title: "\(n) \(i + 1)", subtitle: "눌러서 들어가기")
                                Image(systemName: "chevron.right").foregroundStyle(Theme.faint)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    Text("가장 깊은 화면이에요.\n‹ 를 눌러 한 칸씩 돌아가 보세요.").font(.system(size: 14)).foregroundStyle(Theme.sub)
                        .multilineTextAlignment(.center).padding(.top, 60)
                }
                Spacer()
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.card)
        .shadow(color: depth > 0 ? Color.black.opacity(0.1) : Color.clear, radius: 10, x: -4)
    }
}

// MARK: - 새로고침

struct RefreshDemo: View {
    @State private var rate: Double = 1384.5
    @State private var updated = "9:41:00"
    @State private var spin = 0.0
    @State private var loading = false

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        ScreenTitle(text: "환율")
                        Button { refresh() } label: {
                            IconTile(symbol: "arrow.clockwise", tint: Theme.blue)
                                .rotationEffect(.degrees(spin))
                        }
                        .disabled(loading)
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text("🇺🇸 1 USD").font(.system(size: 14)).foregroundStyle(Theme.sub)
                        Text(String(format: "%.1f원", rate)).font(.system(size: 34, weight: .bold)).foregroundStyle(Theme.text)
                            .contentTransition(.numericText())
                        Text("업데이트 \(updated)").font(.system(size: 12)).foregroundStyle(Theme.sub).monospacedDigit()
                    }
                    .padding(16).frame(maxWidth: .infinity, alignment: .leading)
                    .background(Theme.fill, in: RoundedRectangle(cornerRadius: 16))
                    .opacity(loading ? 0.5 : 1)
                    ForEach(0..<3, id: \.self) { i in
                        MockRow(index: i + 1, title: ["🇯🇵 100 JPY", "🇪🇺 1 EUR", "🇨🇳 1 CNY"][i], subtitle: "실시간 시세", symbol: "chart.line.uptrend.xyaxis")
                    }
                    Spacer(minLength: 0)
                }
                .padding(16)
            }
            DemoNote(text: "↻ 는 ‘바깥 세상의 최신 값’을 다시 가져와요. 내가 한 행동과는 상관없어요.")
        }
    }

    private func refresh() {
        loading = true
        withAnimation(.easeInOut(duration: 0.8)) { spin += 360 }
        delay(0.8) {
            let f = DateFormatter()
            f.dateFormat = "H:mm:ss"
            withAnimation(.spring(duration: 0.4)) {
                rate = 1384.5 + Double.random(in: -12...12)
                updated = f.string(from: Date())
            }
            loading = false
            Haptic.success()
        }
    }
}

// MARK: - 되돌리기

struct UndoDemo: View {
    @State private var cells: [Int?] = Array(repeating: nil, count: 16)
    @State private var history: [(Int, Int?)] = []
    @State private var color = 1

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        ScreenTitle(text: "픽셀 그림판")
                        Button { undo() } label: {
                            IconTile(symbol: "arrow.uturn.backward", tint: history.isEmpty ? Theme.faint : Theme.blue)
                        }
                        .disabled(history.isEmpty)
                    }
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 4), spacing: 6) {
                        ForEach(0..<16, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(cells[i].map { Theme.deep($0) } ?? Theme.fill)
                                .aspectRatio(1, contentMode: .fit)
                                .onTapGesture { paint(i) }
                        }
                    }
                    HStack(spacing: 10) {
                        ForEach(0..<5, id: \.self) { c in
                            Circle().fill(Theme.deep(c)).frame(width: 30, height: 30)
                                .overlay(Circle().strokeBorder(Theme.text, lineWidth: color == c ? 3 : 0))
                                .onTapGesture { color = c }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    Text("기록 \(history.count)개").font(.system(size: 12)).foregroundStyle(Theme.sub)
                    Spacer(minLength: 0)
                }
                .padding(16)
            }
            DemoNote(text: history.isEmpty ? "칸을 몇 개 칠한 뒤 ↶ 를 눌러보세요." : "↶ 를 누를 때마다 내가 한 행동이 한 단계씩 취소돼요.")
        }
    }

    private func paint(_ i: Int) {
        history.append((i, cells[i]))
        withAnimation(.spring(duration: 0.2)) { cells[i] = cells[i] == color ? nil : color }
        Haptic.selection()
    }

    private func undo() {
        guard let last = history.popLast() else { return }
        withAnimation(.spring(duration: 0.25)) { cells[last.0] = last.1 }
        Haptic.impact(.light)
    }
}

// MARK: - 검색 아이콘

struct SearchIconDemo: View {
    @State private var searching = false
    @State private var query = ""
    @FocusState private var focused: Bool
    private let items = ["사과", "바나나", "블루베리", "딸기", "수박", "참외", "복숭아", "포도"]

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        if searching {
                            HStack(spacing: 6) {
                                Image(systemName: "magnifyingglass").foregroundStyle(Theme.sub)
                                TextField("과일 찾기", text: $query).focused($focused)
                            }
                            .padding(.horizontal, 12).frame(height: 40)
                            .background(Theme.fill, in: RoundedRectangle(cornerRadius: 12))
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                            Button("취소") { withAnimation(.spring(duration: 0.3)) { searching = false; query = "" } }
                                .foregroundStyle(Theme.blue)
                        } else {
                            ScreenTitle(text: "과일 가게")
                            Button {
                                withAnimation(.spring(duration: 0.3)) { searching = true }
                                delay(0.1) { focused = true }
                            } label: { IconTile(symbol: "magnifyingglass") }
                        }
                    }
                    .frame(height: 40)
                    let shown = items.filter { query.isEmpty || $0.contains(query) }
                    ForEach(shown, id: \.self) { f in
                        Text(f).font(.system(size: 15)).foregroundStyle(Theme.text)
                            .frame(maxWidth: .infinity, alignment: .leading).frame(height: 30)
                    }
                    Spacer(minLength: 0)
                }
                .padding(16)
            }
            DemoNote(text: searching ? "입력창이 열렸어요. 검색은 ‘찾는’ 기능이라 글자를 입력해야 해요." : "속이 빈 돋보기를 눌러보세요.")
        }
    }
}

// MARK: - 확대

struct ZoomInDemo: View {
    @State private var scale: CGFloat = 1
    @GestureState private var pinch: CGFloat = 1

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(spacing: 0) {
                    HStack {
                        ScreenTitle(text: "지도")
                        Button { zoom(out: true) } label: { IconTile(symbol: "minus.magnifyingglass", tint: scale <= 1 ? Theme.faint : Theme.text) }
                        Button { zoom(out: false) } label: { IconTile(symbol: "plus.magnifyingglass", tint: scale >= 3 ? Theme.faint : Theme.blue) }
                    }
                    .padding(.horizontal, 16).padding(.bottom, 8)
                    ZStack {
                        mapArt
                            .scaleEffect(min(4, max(1, scale * pinch)))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .contentShape(Rectangle())
                    .gesture(
                        MagnifyGesture()
                            .updating($pinch) { v, s, _ in s = v.magnification }
                            .onEnded { v in withAnimation(.spring(duration: 0.3)) { scale = min(4, max(1, scale * v.magnification)) } }
                    )
                    .overlay(alignment: .bottomLeading) {
                        Text(String(format: "%.1fx", min(4, max(1, scale * pinch))))
                            .font(.system(size: 13, weight: .bold)).foregroundStyle(.white).monospacedDigit()
                            .padding(.horizontal, 10).padding(.vertical, 5)
                            .background(Color.black.opacity(0.5), in: Capsule())
                            .padding(12)
                    }
                }
            }
            DemoNote(text: "＋돋보기는 검색창을 열지 않고 화면을 크게 키워요. 두 손가락으로 벌려도 똑같아요.")
        }
    }

    private var mapArt: some View {
        ZStack {
            Color(hex: 0xDDF0E3)
            Path { p in
                p.move(to: CGPoint(x: 0, y: 120)); p.addCurve(to: CGPoint(x: 300, y: 200), control1: CGPoint(x: 100, y: 60), control2: CGPoint(x: 200, y: 260))
            }
            .stroke(Color(hex: 0x8CC8FF), lineWidth: 18)
            Path { p in
                p.move(to: CGPoint(x: 140, y: 0)); p.addLine(to: CGPoint(x: 160, y: 420))
                p.move(to: CGPoint(x: 0, y: 300)); p.addLine(to: CGPoint(x: 300, y: 280))
            }
            .stroke(Color.white, lineWidth: 8)
            Image(systemName: "mappin.circle.fill").font(.system(size: 30)).foregroundStyle(Theme.red).offset(x: 10, y: 10)
            Text("우리 집").font(.system(size: 8, weight: .bold)).foregroundStyle(Theme.text).offset(x: 10, y: 34)
            Image(systemName: "cup.and.saucer.fill").font(.system(size: 12)).foregroundStyle(Color(hex: 0x8B5E3C)).offset(x: -60, y: -40)
            Image(systemName: "tree.fill").font(.system(size: 14)).foregroundStyle(Theme.green).offset(x: 70, y: -90)
        }
    }

    private func zoom(out: Bool) {
        withAnimation(.spring(duration: 0.35)) { scale = out ? max(1, scale - 0.5) : min(3, scale + 0.5) }
        Haptic.tap()
    }
}

// MARK: - 필터 & 정렬 공용 상품

struct Product: Identifiable, Equatable {
    let id: Int
    let name: String
    let category: String
    let price: Int
    let symbol: String

    static let all: [Product] = [
        Product(id: 0, name: "후드티", category: "의류", price: 39000, symbol: "tshirt.fill"),
        Product(id: 1, name: "운동화", category: "신발", price: 89000, symbol: "shoe.fill"),
        Product(id: 2, name: "에코백", category: "가방", price: 19000, symbol: "bag.fill"),
        Product(id: 3, name: "청바지", category: "의류", price: 59000, symbol: "figure.walk"),
        Product(id: 4, name: "샌들", category: "신발", price: 29000, symbol: "shoe.2.fill"),
        Product(id: 5, name: "백팩", category: "가방", price: 69000, symbol: "backpack.fill"),
        Product(id: 6, name: "셔츠", category: "의류", price: 45000, symbol: "tshirt"),
        Product(id: 7, name: "토트백", category: "가방", price: 99000, symbol: "handbag.fill"),
    ]
}

struct ProductRow: View {
    let p: Product
    var body: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 10).fill(Theme.pastel(p.id)).frame(width: 34, height: 34)
                .overlay(Image(systemName: p.symbol).font(.system(size: 14)).foregroundStyle(Theme.deep(p.id)))
            Text(p.name).font(.system(size: 14, weight: .semibold)).foregroundStyle(Theme.text)
            Text(p.category).font(.system(size: 11)).foregroundStyle(Theme.sub)
            Spacer()
            Text("\(p.price / 1000),000원").font(.system(size: 13, weight: .semibold)).foregroundStyle(Theme.text)
        }
        .frame(height: 38)
    }
}

// MARK: - 필터

struct FilterDemo: View {
    @State private var open = false
    @State private var categories: Set<String> = []
    @State private var draft: Set<String> = []

    private var shown: [Product] {
        Product.all.filter { categories.isEmpty || categories.contains($0.category) }
    }

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame(height: 520) {
                ZStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            ScreenTitle(text: "상품")
                            Button {
                                draft = categories
                                withAnimation(.spring(duration: 0.35)) { open = true }
                            } label: {
                                IconTile(symbol: categories.isEmpty ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill", tint: categories.isEmpty ? Theme.text : Theme.blue)
                            }
                        }
                        Text("\(Product.all.count)개 중 \(shown.count)개").font(.system(size: 13, weight: .semibold)).foregroundStyle(Theme.blue)
                            .contentTransition(.numericText())
                        ForEach(shown) { p in
                            ProductRow(p: p).transition(.opacity.combined(with: .scale(scale: 0.9)))
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(16)
                    .animation(.spring(duration: 0.35), value: categories)

                    if open {
                        Color.black.opacity(0.35).onTapGesture { withAnimation { open = false } }.transition(.opacity)
                        VStack(alignment: .leading, spacing: 14) {
                            Grabber().frame(maxWidth: .infinity)
                            Text("필터").font(.system(size: 17, weight: .bold)).foregroundStyle(Theme.text)
                            Text("카테고리").font(.system(size: 13)).foregroundStyle(Theme.sub)
                            HStack(spacing: 8) {
                                ForEach(["의류", "신발", "가방"], id: \.self) { c in
                                    Button {
                                        if draft.contains(c) { draft.remove(c) } else { draft.insert(c) }
                                    } label: {
                                        Text(c).font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(draft.contains(c) ? Color.white : Theme.text)
                                            .padding(.horizontal, 16).frame(height: 36)
                                            .background(draft.contains(c) ? Theme.blue : Theme.fill, in: Capsule())
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            HStack(spacing: 8) {
                                Button("초기화") { draft = [] }.buttonStyle(DSButtonStyle(kind: .ghost)).frame(width: 90)
                                Button("\(Product.all.filter { draft.isEmpty || draft.contains($0.category) }.count)개 보기") {
                                    categories = draft
                                    withAnimation(.spring(duration: 0.35)) { open = false }
                                }
                                .buttonStyle(DSButtonStyle())
                            }
                        }
                        .padding(18)
                        .background(Theme.card, in: SheetShape())
                        .transition(.move(edge: .bottom))
                    }
                }
            }
            DemoNote(text: categories.isEmpty ? "필터 아이콘을 눌러 카테고리를 골라보세요." : "조건에 맞지 않는 상품이 사라져서 개수가 \(shown.count)개로 줄었어요.")
        }
    }
}

// MARK: - 정렬

struct SortDemo: View {
    enum Order: String, CaseIterable { case recommend = "추천순", low = "낮은 가격순", high = "높은 가격순", name = "이름순" }
    @State private var order: Order = .recommend

    private var sorted: [Product] {
        switch order {
        case .recommend: return Product.all
        case .low: return Product.all.sorted { $0.price < $1.price }
        case .high: return Product.all.sorted { $0.price > $1.price }
        case .name: return Product.all.sorted { $0.name < $1.name }
        }
    }

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame(height: 520) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        ScreenTitle(text: "상품")
                        Menu {
                            Picker("정렬", selection: $order.animation(.spring(duration: 0.5))) {
                                ForEach(Order.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                            }
                        } label: {
                            HStack(spacing: 2) {
                                Text(order.rawValue).font(.system(size: 13, weight: .semibold))
                                Image(systemName: "arrow.up.arrow.down").font(.system(size: 15, weight: .semibold))
                            }
                            .foregroundStyle(Theme.blue)
                            .padding(.horizontal, 10).frame(height: 34)
                            .background(Theme.blueSoft, in: Capsule())
                        }
                    }
                    Text("\(Product.all.count)개 중 \(sorted.count)개 · 개수는 그대로").font(.system(size: 13, weight: .semibold)).foregroundStyle(Theme.sub)
                    ForEach(sorted) { p in ProductRow(p: p) }
                    Spacer(minLength: 0)
                }
                .padding(16)
            }
            DemoNote(text: "‘\(order.rawValue)’으로 정렬했어요. 상품은 하나도 사라지지 않고 줄 서는 순서만 바뀌어요.")
        }
    }
}

// MARK: - 수정

struct EditDemo: View {
    @State private var editing = false
    @State private var name = "우디"
    @State private var bio = "UI를 공부하는 디자이너"
    @State private var draftName = ""
    @State private var draftBio = ""

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        ScreenTitle(text: "내 프로필")
                        if editing {
                            Button("완료") {
                                name = draftName.isEmpty ? name : draftName
                                bio = draftBio
                                withAnimation(.spring(duration: 0.3)) { editing = false }
                                Haptic.success()
                            }
                            .font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.blue)
                        } else {
                            Button {
                                draftName = name; draftBio = bio
                                withAnimation(.spring(duration: 0.3)) { editing = true }
                            } label: { IconTile(symbol: "pencil", tint: Theme.blue) }
                        }
                    }
                    Circle().fill(Theme.pastel(1)).frame(width: 80, height: 80)
                        .overlay(Text("🙂").font(.system(size: 40)))
                        .frame(maxWidth: .infinity)
                    Text("이름").font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.sub)
                    if editing {
                        FieldBox(focused: true) { TextField("이름", text: $draftName) }
                    } else {
                        Text(name).font(.system(size: 17, weight: .bold)).foregroundStyle(Theme.text)
                    }
                    Text("소개").font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.sub)
                    if editing {
                        FieldBox { TextField("소개", text: $draftBio) }
                    } else {
                        Text(bio).font(.system(size: 15)).foregroundStyle(Theme.text)
                    }
                    Spacer(minLength: 0)
                }
                .padding(16)
            }
            DemoNote(text: editing ? "원래 있던 내용이 채워진 채로 열렸어요. 이게 ‘수정’이에요." : "연필 아이콘을 눌러보세요.")
        }
    }
}

// MARK: - 새 글

struct ComposeDemo: View {
    @State private var posts = ["오늘 날씨 좋다 ☀️", "UI 도감 재밌네"]
    @State private var composing = false
    @State private var text = ""
    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            ScreenTitle(text: "메모 \(posts.count)")
                            Button {
                                text = ""
                                withAnimation(.spring(duration: 0.4)) { composing = true }
                                delay(0.35) { focused = true }
                            } label: { IconTile(symbol: "square.and.pencil", tint: Theme.blue) }
                        }
                        ForEach(posts, id: \.self) { p in
                            Text(p).font(.system(size: 14)).foregroundStyle(Theme.text)
                                .padding(14).frame(maxWidth: .infinity, alignment: .leading)
                                .background(Theme.fill, in: RoundedRectangle(cornerRadius: 12))
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(16)

                    if composing {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Button("취소") { withAnimation(.spring(duration: 0.35)) { composing = false } }
                                    .foregroundStyle(Theme.sub)
                                Spacer()
                                Text("새 메모").font(.system(size: 16, weight: .bold)).foregroundStyle(Theme.text)
                                Spacer()
                                Button("올리기") {
                                    let t = text.trimmingCharacters(in: .whitespaces)
                                    withAnimation(.spring(duration: 0.4)) {
                                        posts.insert(t.isEmpty ? "새 메모 \(posts.count + 1)" : t, at: 0)
                                        composing = false
                                    }
                                    Haptic.success()
                                }
                                .fontWeight(.bold).foregroundStyle(Theme.blue)
                            }
                            .font(.system(size: 15))
                            TextField("무슨 생각을 하고 있나요?", text: $text, axis: .vertical)
                                .focused($focused)
                                .font(.system(size: 16))
                                .padding(.top, 10)
                            Spacer()
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Theme.card)
                        .transition(.move(edge: .bottom))
                    }
                }
            }
            DemoNote(text: composing ? "아무것도 없는 ‘빈’ 화면에서 시작해요. 수정과 달라요." : "오른쪽 위 네모+연필 아이콘을 눌러보세요.")
        }
    }
}
