import SwiftUI
import UIKit

// MARK: - 상단 바

struct TopBarDemo: View {
    @State private var path: [String] = []
    @State private var annotate = false
    @State private var saved = false

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack {
                    if let current = path.last {
                        detail(current)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                            .zIndex(1)
                    } else {
                        list
                            .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                }
                .clipped()
            }
            Toggle("부분 이름 보기", isOn: $annotate.animation())
                .font(.system(size: 15, weight: .semibold)).tint(Theme.blue)
                .padding(.horizontal, 16).frame(height: 50)
                .background(Theme.fill, in: RoundedRectangle(cornerRadius: 14))
            DemoNote(text: path.isEmpty ? "항목을 눌러 한 단계 들어가 보세요." : "상단 바의 제목이 ‘\(path.last ?? "")’로 바뀌었고, 왼쪽에 돌아갈 곳(설정)이 보여요.")
        }
    }

    private var list: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("설정").font(.system(size: 26, weight: .bold)).foregroundStyle(Theme.text)
                    .overlay(alignment: .bottomLeading) { tag("큰 제목", y: 18) }
                Spacer()
            }
            .padding(.horizontal, 16).padding(.top, 8).padding(.bottom, 16)
            ForEach(["알림", "개인정보", "화면", "소리"], id: \.self) { item in
                Button {
                    withAnimation(.spring(duration: 0.4)) { path.append(item) }
                } label: {
                    HStack {
                        Text(item).font(.system(size: 15)).foregroundStyle(Theme.text)
                        Spacer()
                        Image(systemName: "chevron.right").font(.system(size: 13)).foregroundStyle(Theme.faint)
                    }
                    .padding(.horizontal, 16).frame(height: 50)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
        .background(Theme.card)
    }

    private func detail(_ title: String) -> some View {
        VStack(spacing: 0) {
            ZStack {
                Text(title).font(.system(size: 16, weight: .bold)).foregroundStyle(Theme.text)
                    .overlay(alignment: .bottom) { tag("제목", y: 18) }
                HStack {
                    Button {
                        withAnimation(.spring(duration: 0.4)) { _ = path.popLast() }
                    } label: {
                        HStack(spacing: 2) {
                            Image(systemName: "chevron.left").font(.system(size: 16, weight: .semibold))
                            Text("설정").font(.system(size: 15))
                        }
                        .foregroundStyle(Theme.blue)
                    }
                    .overlay(alignment: .bottomLeading) { tag("뒤로가기", y: 18) }
                    Spacer()
                    Button(saved ? "저장됨" : "저장") { saved.toggle(); Haptic.success() }
                        .font(.system(size: 15, weight: .semibold)).foregroundStyle(Theme.blue)
                        .overlay(alignment: .bottomTrailing) { tag("액션", y: 18) }
                }
                .padding(.horizontal, 12)
            }
            .frame(height: 44)
            .background(Theme.card)
            .overlay(alignment: .bottom) { Rectangle().fill(Theme.fillStrong).frame(height: 0.5) }
            .zIndex(1)

            VStack(spacing: 12) {
                ForEach(0..<4, id: \.self) { i in
                    Toggle("\(title) 옵션 \(i + 1)", isOn: .constant(i % 2 == 0)).font(.system(size: 14)).tint(Theme.blue)
                }
                Spacer()
            }
            .padding(16)
            .padding(.top, annotate ? 14 : 0)
        }
        .background(Theme.card)
    }

    @ViewBuilder
    private func tag(_ text: String, y: CGFloat) -> some View {
        if annotate {
            Text(text)
                .font(.system(size: 10, weight: .bold)).foregroundStyle(.white)
                .padding(.horizontal, 6).padding(.vertical, 3)
                .background(Theme.red, in: Capsule())
                .fixedSize()
                .offset(y: y)
                .transition(.scale.combined(with: .opacity))
        }
    }
}

// MARK: - 탭 바

struct TabBarDemo: View {
    @State private var tab = 0
    private let tabs = [("홈", "house"), ("검색", "magnifyingglass"), ("알림", "bell"), ("내 정보", "person")]
    private func icon(_ i: Int) -> String {
        if tabs[i].1 == "magnifyingglass" { return tabs[i].1 }
        return tab == i ? tabs[i].1 + ".fill" : tabs[i].1
    }

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(spacing: 0) {
                    ZStack {
                        content(tab)
                            .id(tab)
                            .transition(.opacity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .animation(.easeInOut(duration: 0.2), value: tab)

                    HStack {
                        ForEach(tabs.indices, id: \.self) { i in
                            Button {
                                tab = i
                                Haptic.selection()
                            } label: {
                                VStack(spacing: 3) {
                                    Image(systemName: icon(i))
                                        .font(.system(size: 20))
                                        .symbolEffect(.bounce, value: tab == i)
                                    Text(tabs[i].0).font(.system(size: 10, weight: .medium))
                                }
                                .foregroundStyle(tab == i ? Theme.blue : Theme.faint)
                                .frame(maxWidth: .infinity).frame(height: 52)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.bottom, 8)
                    .background(Theme.card)
                    .overlay(alignment: .top) { Rectangle().fill(Theme.fillStrong).frame(height: 0.5) }
                }
            }
            DemoNote(text: "탭을 누를 때마다 화면 전체가 다른 ‘구역’으로 바뀌어요. 탭 바 자체는 항상 그대로예요.")
        }
    }

    @ViewBuilder
    private func content(_ i: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ScreenTitle(text: tabs[i].0)
            switch i {
            case 0:
                RoundedRectangle(cornerRadius: 16).fill(Theme.pastel(1)).frame(height: 110)
                    .overlay(Text("오늘의 추천").font(.system(size: 16, weight: .bold)).foregroundStyle(Theme.deep(1)))
                ForEach(0..<2, id: \.self) { j in MockRow(index: j + 2, title: "추천 콘텐츠 \(j + 1)", subtitle: "홈 탭의 내용") }
            case 1:
                HStack { Image(systemName: "magnifyingglass"); Text("무엇이든 검색").foregroundStyle(Theme.faint); Spacer() }
                    .padding(12).background(Theme.fill, in: RoundedRectangle(cornerRadius: 12))
                ForEach(["인기 검색어 1", "인기 검색어 2", "인기 검색어 3"], id: \.self) { Text($0).font(.system(size: 14)).foregroundStyle(Theme.text) }
            case 2:
                ForEach(0..<4, id: \.self) { j in MockRow(index: j, title: "새 알림 \(j + 1)", subtitle: "\(j + 1)시간 전", symbol: "bell.fill") }
            default:
                HStack(spacing: 12) {
                    Circle().fill(Theme.blueSoft).frame(width: 56, height: 56).overlay(Text("🙂").font(.system(size: 28)))
                    VStack(alignment: .leading) {
                        Text("우디").font(.system(size: 17, weight: .bold)).foregroundStyle(Theme.text)
                        Text("프로필 보기").font(.system(size: 13)).foregroundStyle(Theme.sub)
                    }
                }
                MockRow(index: 4, title: "설정", symbol: "gearshape.fill")
            }
            Spacer(minLength: 0)
        }
        .padding(16)
    }
}

// MARK: - 캐러셀

struct CarouselDemo: View {
    @State private var page = 0
    @State private var auto = true
    private let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()
    private let banners: [(String, String, [Color])] = [
        ("🎉", "첫 구매 50% 할인", [Color(hex: 0x6E8BFF), Color(hex: 0xB06BFF)]),
        ("☕️", "커피 쿠폰 받기", [Color(hex: 0xFF8A5B), Color(hex: 0xFFB800)]),
        ("✈️", "여름 여행 특가", [Color(hex: 0x15C47E), Color(hex: 0x3182F6)]),
        ("🎁", "친구 초대 이벤트", [Color(hex: 0xF04452), Color(hex: 0xFF8A5B)]),
    ]

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 12) {
                    ScreenTitle(text: "홈").padding(.horizontal, 16)
                    TabView(selection: $page) {
                        ForEach(banners.indices, id: \.self) { i in
                            let b = banners[i]
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(LinearGradient(colors: b.2, startPoint: .topLeading, endPoint: .bottomTrailing))
                                .overlay(alignment: .bottomLeading) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(b.0).font(.system(size: 36))
                                        Text(b.1).font(.system(size: 18, weight: .bold)).foregroundStyle(.white)
                                    }
                                    .padding(18)
                                }
                                .overlay(alignment: .topTrailing) {
                                    Text("\(i + 1) / \(banners.count)")
                                        .font(.system(size: 11, weight: .semibold)).foregroundStyle(.white)
                                        .padding(.horizontal, 8).padding(.vertical, 4)
                                        .background(Color.black.opacity(0.25), in: Capsule())
                                        .padding(12)
                                }
                                .padding(.horizontal, 16)
                                .tag(i)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: 180)

                    HStack(spacing: 6) {
                        ForEach(banners.indices, id: \.self) { i in
                            Capsule().fill(i == page ? Theme.blue : Theme.fillStrong)
                                .frame(width: i == page ? 18 : 7, height: 7)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .animation(.spring(duration: 0.3), value: page)

                    VStack(spacing: 10) {
                        ForEach(0..<2, id: \.self) { j in MockRow(index: j + 3, title: "아래 콘텐츠 \(j + 1)", subtitle: "캐러셀은 홈 상단에 많이 써요") }
                    }
                    .padding(.horizontal, 16)
                    Spacer(minLength: 0)
                }
            }
            Toggle("자동으로 넘기기", isOn: $auto)
                .font(.system(size: 15, weight: .semibold)).tint(Theme.blue)
                .padding(.horizontal, 16).frame(height: 50)
                .background(Theme.fill, in: RoundedRectangle(cornerRadius: 14))
            DemoNote(text: "한 장씩 꽉 차게 보이고, 넘기면 다음 장에 ‘딱’ 멈춰요. 아래 점이 위치를 알려줘요.")
        }
        .onReceive(timer) { _ in
            guard auto else { return }
            withAnimation(.easeInOut(duration: 0.5)) { page = (page + 1) % banners.count }
        }
    }
}

// MARK: - 가로 스크롤

struct HorizontalScrollDemo: View {
    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 18) {
                    ScreenTitle(text: "쇼핑").padding(.horizontal, 16)
                    section("추천 상품", icons: ["tshirt.fill", "shoe.fill", "bag.fill", "eyeglasses", "watch.analog", "headphones", "backpack.fill"], width: 104)
                    section("카테고리", icons: ["cup.and.saucer.fill", "fork.knife", "cart.fill", "gift.fill", "leaf.fill", "pawprint.fill", "gamecontroller.fill", "book.fill"], width: 64, small: true)
                    Spacer(minLength: 0)
                }
            }
            DemoNote(text: "카드 여러 장이 동시에 보이고, 오른쪽 카드가 잘려 있어서 ‘더 있다’는 걸 알려줘요. 원하는 곳에서 자유롭게 멈춰요.")
        }
    }

    private func section(_ title: String, icons: [String], width: CGFloat, small: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title).font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                Spacer()
                Text("밀어서 더 보기 →").font(.system(size: 11)).foregroundStyle(Theme.sub)
            }
            .padding(.horizontal, 16)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(icons.indices, id: \.self) { i in
                        VStack(alignment: .leading, spacing: 6) {
                            RoundedRectangle(cornerRadius: small ? 18 : 14, style: .continuous)
                                .fill(Theme.pastel(i))
                                .frame(width: width, height: small ? width : 120)
                                .overlay(Image(systemName: icons[i]).font(.system(size: small ? 22 : 30)).foregroundStyle(Theme.deep(i)))
                            if !small {
                                Text("상품 \(i + 1)").font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.text)
                                Text("\((i + 2) * 7),900원").font(.system(size: 11)).foregroundStyle(Theme.sub)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

// MARK: - 페이지네이션

struct PagingDemo: View {
    @State private var page = 1
    private let total = 5

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 10) {
                    ScreenTitle(text: "자유게시판")
                    VStack(spacing: 0) {
                        ForEach(0..<6, id: \.self) { i in
                            let n = (page - 1) * 6 + i + 1
                            HStack {
                                Text("\(n)").font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.faint).frame(width: 24, alignment: .leading)
                                Text("게시글 제목입니다 #\(n)").font(.system(size: 14)).foregroundStyle(Theme.text)
                                Spacer()
                            }
                            .frame(height: 40)
                            .overlay(alignment: .bottom) { Rectangle().fill(Theme.fill).frame(height: 1) }
                        }
                    }
                    .id(page)
                    .transition(.opacity)
                    Spacer()
                    HStack(spacing: 4) {
                        pageButton(Image(systemName: "chevron.left"), disabled: page == 1) { page -= 1 }
                        ForEach(1...total, id: \.self) { p in
                            Button { withAnimation(.easeInOut(duration: 0.2)) { page = p } } label: {
                                Text("\(p)")
                                    .font(.system(size: 14, weight: p == page ? .bold : .regular))
                                    .foregroundStyle(p == page ? Color.white : Theme.text)
                                    .frame(width: 32, height: 32)
                                    .background(p == page ? Theme.blue : Color.clear, in: RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                        }
                        pageButton(Image(systemName: "chevron.right"), disabled: page == total) { page += 1 }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(16)
            }
            DemoNote(text: "지금 \(total)페이지 중 \(page)페이지예요. 번호로 원하는 위치에 바로 갈 수 있어요.")
        }
    }

    private func pageButton(_ image: Image, disabled: Bool, action: @escaping () -> Void) -> some View {
        Button { withAnimation(.easeInOut(duration: 0.2)) { action() } } label: {
            image.font(.system(size: 13, weight: .semibold))
                .foregroundStyle(disabled ? Theme.fillStrong : Theme.text)
                .frame(width: 32, height: 32)
        }
        .disabled(disabled)
    }
}

// MARK: - 무한 스크롤

struct InfiniteScrollDemo: View {
    @State private var count = 10
    @State private var loading = false
    private let limit = 60

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(spacing: 0) {
                    HStack {
                        ScreenTitle(text: "피드")
                        Text("\(count)개 불러옴").font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.blue)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Theme.blueSoft, in: Capsule())
                            .contentTransition(.numericText())
                    }
                    .padding(.horizontal, 16).padding(.bottom, 8)
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(0..<count, id: \.self) { i in
                                MockRow(index: i, title: "피드 글 #\(i + 1)", subtitle: i >= 10 ? "자동으로 이어 붙은 글" : "처음 불러온 글", symbol: "photo.fill")
                                    .onAppear { if i == count - 1 { loadMore() } }
                            }
                            if count < limit {
                                ProgressView().padding(.vertical, 12)
                            } else {
                                Text("모든 글을 다 봤어요").font(.system(size: 12)).foregroundStyle(Theme.sub).padding(.vertical, 12)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            DemoNote(text: "끝까지 내려보세요. 버튼을 누르지 않아도 다음 글이 저절로 이어 붙어요.")
        }
    }

    private func loadMore() {
        guard !loading, count < limit else { return }
        loading = true
        delay(0.9) {
            withAnimation { count = min(limit, count + 10) }
            loading = false
        }
    }
}

// MARK: - 플로팅 버튼

struct FABDemo: View {
    @State private var expanded = false
    @State private var note = "목록을 스크롤해 보세요. 버튼은 계속 떠 있어요."

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack(alignment: .bottomTrailing) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ScreenTitle(text: "메모")
                            ForEach(0..<14, id: \.self) { i in
                                MockRow(index: i, title: "메모 \(i + 1)", subtitle: "스크롤해도 ＋는 그 자리에", symbol: "note.text")
                            }
                        }
                        .padding(16)
                    }
                    if expanded {
                        Color.black.opacity(0.3)
                            .onTapGesture { toggle() }
                            .transition(.opacity)
                    }
                    VStack(alignment: .trailing, spacing: 12) {
                        if expanded {
                            ForEach(Array([("글쓰기", "pencil"), ("사진", "photo"), ("투표", "chart.bar")].enumerated()), id: \.offset) { idx, item in
                                Button {
                                    note = "‘\(item.0)’를 골랐어요. 플로팅 버튼은 이렇게 관련 행동을 펼칠 수도 있어요."
                                    toggle()
                                } label: {
                                    HStack(spacing: 8) {
                                        Text(item.0).font(.system(size: 13, weight: .semibold)).foregroundStyle(Theme.text)
                                            .padding(.horizontal, 10).padding(.vertical, 6)
                                            .background(Theme.card, in: Capsule())
                                        Circle().fill(Theme.card).frame(width: 42, height: 42)
                                            .overlay(Image(systemName: item.1).foregroundStyle(Theme.blue))
                                            .shadow(color: .black.opacity(0.15), radius: 6, y: 2)
                                    }
                                }
                                .buttonStyle(PressStyle())
                                .transition(.scale(scale: 0.5, anchor: .bottomTrailing).combined(with: .opacity).animation(.spring(duration: 0.3).delay(Double(2 - idx) * 0.04)))
                            }
                        }
                        Button { toggle() } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold)).foregroundStyle(.white)
                                .rotationEffect(.degrees(expanded ? 45 : 0))
                                .frame(width: 58, height: 58)
                                .background(Theme.blue, in: Circle())
                                .shadow(color: Theme.blue.opacity(0.45), radius: 12, y: 6)
                        }
                        .buttonStyle(PressStyle())
                    }
                    .padding(18)
                }
            }
            DemoNote(text: note)
        }
    }

    private func toggle() {
        withAnimation(.spring(duration: 0.35)) { expanded.toggle() }
        Haptic.tap()
    }
}

// MARK: - 하단 고정 버튼

struct StickyButtonDemo: View {
    @State private var toast = false

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack(alignment: .bottom) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 14) {
                            RoundedRectangle(cornerRadius: 18).fill(Theme.pastel(1)).frame(height: 160)
                                .overlay(Image(systemName: "headphones").font(.system(size: 60)).foregroundStyle(Theme.deep(1)))
                            Text("노이즈 캔슬링 헤드폰").font(.system(size: 19, weight: .bold)).foregroundStyle(Theme.text)
                            Text("129,000원").font(.system(size: 22, weight: .heavy)).foregroundStyle(Theme.text)
                            ForEach(0..<8, id: \.self) { i in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(["상품 설명", "배송 안내", "교환·반품", "리뷰 (128)", "Q&A", "판매자 정보", "추천 상품", "비슷한 상품"][i])
                                        .font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                                    SkeletonBar(height: 9)
                                    SkeletonBar(width: 180, height: 9)
                                }
                            }
                        }
                        .padding(16)
                    }
                    .safeAreaInset(edge: .bottom) {
                        HStack(spacing: 8) {
                            Image(systemName: "heart").font(.system(size: 20)).foregroundStyle(Theme.sub)
                                .frame(width: 50, height: 50)
                                .background(Theme.fill, in: RoundedRectangle(cornerRadius: 14))
                            Button("구매하기") {
                                withAnimation { toast = true }
                                delay(1.5) { withAnimation { toast = false } }
                            }
                            .buttonStyle(DSButtonStyle())
                        }
                        .padding(.horizontal, 14).padding(.top, 10).padding(.bottom, 14)
                        .background(Theme.card.shadow(.drop(color: .black.opacity(0.06), radius: 8, y: -4)))
                    }
                    if toast {
                        ToastPill(text: "구매 화면으로 이동해요").padding(.bottom, 90).transition(.opacity)
                    }
                }
            }
            DemoNote(text: "상품 정보를 끝까지 스크롤해도 ‘구매하기’는 항상 맨 아래에 붙어 있어요.")
        }
    }
}

// MARK: - 아코디언

struct AccordionDemo: View {
    @State private var openSet: Set<Int> = [0]
    @State private var single = false
    private let faqs = [
        ("배송은 얼마나 걸리나요?", "결제 후 평균 2~3일 걸려요. 제주·도서산간은 하루 더 걸릴 수 있어요."),
        ("환불은 어떻게 하나요?", "주문 내역 > 환불 신청에서 할 수 있어요. 상품 회수 후 3일 안에 환불돼요."),
        ("교환할 수 있나요?", "받은 날로부터 7일 안에 같은 상품의 다른 옵션으로 교환할 수 있어요."),
        ("영수증은 어디서 보나요?", "주문 상세 화면 맨 아래 ‘영수증 보기’를 눌러주세요."),
    ]

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ScreenTitle(text: "자주 묻는 질문").padding(.bottom, 6)
                        ForEach(faqs.indices, id: \.self) { i in
                            VStack(alignment: .leading, spacing: 0) {
                                Button { toggle(i) } label: {
                                    HStack {
                                        Text("Q").font(.system(size: 15, weight: .heavy)).foregroundStyle(Theme.blue)
                                        Text(faqs[i].0).font(.system(size: 14, weight: .semibold)).foregroundStyle(Theme.text)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                        Image(systemName: "chevron.down").font(.system(size: 12, weight: .bold)).foregroundStyle(Theme.sub)
                                            .rotationEffect(.degrees(openSet.contains(i) ? 180 : 0))
                                    }
                                    .padding(14)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                                if openSet.contains(i) {
                                    Text(faqs[i].1)
                                        .font(.system(size: 13)).foregroundStyle(Theme.sub)
                                        .padding(.horizontal, 14).padding(.bottom, 14)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            }
                            .background(Theme.fill, in: RoundedRectangle(cornerRadius: 14))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .padding(16)
                }
            }
            Toggle("하나만 펼치기", isOn: $single)
                .font(.system(size: 15, weight: .semibold)).tint(Theme.blue)
                .padding(.horizontal, 16).frame(height: 50)
                .background(Theme.fill, in: RoundedRectangle(cornerRadius: 14))
            DemoNote(text: "질문(제목)을 누르면 그 아래 답변만 펼쳐져요. ‘하나만 펼치기’를 켜면 다른 섹션은 자동으로 접혀요.")
        }
    }

    private func toggle(_ i: Int) {
        withAnimation(.spring(duration: 0.3)) {
            if openSet.contains(i) {
                openSet.remove(i)
            } else {
                if single { openSet = [] }
                openSet.insert(i)
            }
        }
        Haptic.selection()
    }
}

// MARK: - 더보기

struct ShowMoreDemo: View {
    @State private var expanded = false
    @State private var reviewCount = 2
    private let long = "배송이 정말 빨라서 놀랐어요. 포장도 꼼꼼하게 되어 있었고, 실제로 써보니 생각보다 훨씬 가볍고 소리도 좋아요. 노이즈 캔슬링을 켜면 지하철에서도 조용하고, 배터리도 일주일은 거뜬하네요. 색상은 사진보다 조금 더 밝은 편이에요. 다음에도 여기서 살 것 같아요!"

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ScreenTitle(text: "리뷰")
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("⭐️⭐️⭐️⭐️⭐️").font(.system(size: 12))
                                Spacer()
                                Text("우디").font(.system(size: 12)).foregroundStyle(Theme.sub)
                            }
                            Text(long)
                                .font(.system(size: 14)).foregroundStyle(Theme.text)
                                .lineLimit(expanded ? nil : 3)
                            Button(expanded ? "접기" : "더보기") {
                                withAnimation(.spring(duration: 0.35)) { expanded.toggle() }
                            }
                            .font(.system(size: 13, weight: .semibold)).foregroundStyle(Theme.blue)
                        }
                        .padding(14)
                        .background(Theme.fill, in: RoundedRectangle(cornerRadius: 14))

                        ForEach(0..<reviewCount, id: \.self) { i in
                            MockRow(index: i + 1, title: ["좋아요!", "가성비 최고", "재구매 의사 있어요", "선물용으로 샀어요", "튼튼해요", "색이 예뻐요"][i % 6], subtitle: "⭐️⭐️⭐️⭐️ · 리뷰 \(i + 2)")
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                        if reviewCount < 8 {
                            Button("리뷰 더보기 (\(8 - reviewCount)개 남음)") {
                                withAnimation(.spring(duration: 0.35)) { reviewCount = min(8, reviewCount + 3) }
                            }
                            .buttonStyle(DSButtonStyle(kind: .ghost, compact: true, fullWidth: true))
                            .frame(maxWidth: .infinity)
                        } else {
                            Button("접기") { withAnimation { reviewCount = 2 } }
                                .buttonStyle(DSButtonStyle(kind: .ghost, compact: true))
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(16)
                }
            }
            DemoNote(text: "잘린 글은 그 자리에서 이어서 펼쳐지고, 목록은 버튼을 ‘직접 눌러야’ 더 불러와요.")
        }
    }
}

// MARK: - 스와이프 액션

struct SwipeActionsDemo: View {
    struct Mail: Identifiable { let id: Int; let from: String; var read: Bool; var pinned: Bool }
    @State private var mails: [Mail] = [
        Mail(id: 0, from: "디자인 팀", read: false, pinned: false),
        Mail(id: 1, from: "토스뱅크", read: false, pinned: false),
        Mail(id: 2, from: "엄마", read: true, pinned: false),
        Mail(id: 3, from: "쿠팡", read: false, pinned: false),
        Mail(id: 4, from: "노션", read: true, pinned: false),
    ]
    @State private var note = "메일 한 줄을 왼쪽으로, 또는 오른쪽으로 밀어보세요."

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(spacing: 0) {
                    ScreenTitle(text: "메일").padding(.horizontal, 16).padding(.bottom, 6)
                    List {
                        ForEach(mails) { m in
                            HStack(spacing: 10) {
                                Circle().fill(m.read ? Color.clear : Theme.blue).frame(width: 8, height: 8)
                                MockRow(index: m.id, title: m.from, subtitle: m.pinned ? "📌 고정됨" : "메일 내용 미리보기", symbol: "envelope.fill")
                            }
                            .listRowBackground(Theme.card)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    withAnimation { mails.removeAll { $0.id == m.id } }
                                    note = "끝까지 쭉 밀면 첫 번째 동작(삭제)이 바로 실행돼요."
                                } label: { Label("삭제", systemImage: "trash") }
                                Button {
                                    toggle(m.id) { $0.pinned.toggle() }
                                    note = "고정을 바꿨어요."
                                } label: { Label("고정", systemImage: "pin") }
                                .tint(Theme.orange)
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    toggle(m.id) { $0.read.toggle() }
                                    note = "오른쪽으로 밀면 ‘읽음’처럼 다른 행동이 나와요."
                                } label: { Label(m.read ? "안읽음" : "읽음", systemImage: m.read ? "envelope.badge" : "envelope.open") }
                                .tint(Theme.blue)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            DemoNote(text: note)
            Button("메일 되살리기") {
                withAnimation {
                    mails = (0..<5).map { Mail(id: $0, from: ["디자인 팀", "토스뱅크", "엄마", "쿠팡", "노션"][$0], read: $0 % 2 == 0, pinned: false) }
                }
            }
            .buttonStyle(DSButtonStyle(kind: .ghost))
        }
    }

    private func toggle(_ id: Int, _ change: (inout Mail) -> Void) {
        guard let idx = mails.firstIndex(where: { $0.id == id }) else { return }
        withAnimation { change(&mails[idx]) }
    }
}
