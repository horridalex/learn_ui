import SwiftUI
import UIKit

// MARK: - 드롭다운

struct DropdownDemo: View {
    @State private var open = false
    @State private var city = "부산"
    @State private var menuCity = "서울"
    private let cities = ["서울", "부산", "대구", "광주", "대전", "제주"]

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 10) {
                    ScreenTitle(text: "기차 예매")
                    Text("출발지").font(.system(size: 13, weight: .medium)).foregroundStyle(Theme.sub)
                    Button { withAnimation(.spring(duration: 0.3)) { open.toggle() } } label: {
                        HStack {
                            Text(city).font(.system(size: 15, weight: .semibold)).foregroundStyle(Theme.text)
                            Spacer()
                            Image(systemName: "chevron.down").font(.system(size: 13, weight: .bold)).foregroundStyle(Theme.sub)
                                .rotationEffect(.degrees(open ? 180 : 0))
                        }
                        .padding(.horizontal, 14).frame(height: 46)
                        .background(Theme.card, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(open ? Theme.blue : Theme.fillStrong, lineWidth: open ? 2 : 1))
                    }
                    .buttonStyle(.plain)
                    .overlay(alignment: .bottom) {
                        if open {
                            VStack(spacing: 0) {
                                ForEach(cities, id: \.self) { c in
                                    Button {
                                        city = c
                                        Haptic.selection()
                                        withAnimation(.spring(duration: 0.25)) { open = false }
                                    } label: {
                                        HStack {
                                            Text(c).font(.system(size: 14, weight: c == city ? .bold : .regular))
                                                .foregroundStyle(c == city ? Theme.blue : Theme.text)
                                            Spacer()
                                            if c == city { Image(systemName: "checkmark").font(.system(size: 12, weight: .bold)).foregroundStyle(Theme.blue) }
                                        }
                                        .padding(.horizontal, 14).frame(height: 38)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.vertical, 6)
                            .background(Theme.card, in: RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .black.opacity(0.15), radius: 14, y: 6)
                            .alignmentGuide(.bottom) { d in d[.top] - 6 }
                            .transition(.scale(scale: 0.95, anchor: .top).combined(with: .opacity))
                        }
                    }
                    .zIndex(1)

                    Text("도착지 (iOS 메뉴형 드롭다운)").font(.system(size: 13, weight: .medium)).foregroundStyle(Theme.sub).padding(.top, 8)
                    Menu {
                        Picker("도착지", selection: $menuCity) {
                            ForEach(cities, id: \.self) { Text($0).tag($0) }
                        }
                    } label: {
                        HStack {
                            Text(menuCity).font(.system(size: 15, weight: .semibold)).foregroundStyle(Theme.text)
                            Spacer()
                            Image(systemName: "chevron.up.chevron.down").font(.system(size: 12, weight: .bold)).foregroundStyle(Theme.sub)
                        }
                        .padding(.horizontal, 14).frame(height: 46)
                        .background(Theme.card, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.fillStrong, lineWidth: 1))
                    }
                    Spacer()
                    Button("\(city) → \(menuCity) 조회") {}.buttonStyle(DSButtonStyle())
                }
                .padding(16)
            }
            DemoNote(text: open ? "필드 바로 아래로 목록이 ‘떨어지듯’ 펼쳐졌어요. 하나를 고르면 바로 닫혀요." : "‘출발지’ 상자를 눌러보세요.")
        }
    }
}

// MARK: - 피커

struct PickerDemo: View {
    @State private var open = false
    @State private var place = "강릉"
    @State private var temp = "강릉"
    private let places = ["서울", "제주", "강릉", "여수", "부산", "경주", "전주"]

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                ZStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 10) {
                        ScreenTitle(text: "여행 계획")
                        Text("여행지").font(.system(size: 13, weight: .medium)).foregroundStyle(Theme.sub)
                        Button {
                            temp = place
                            withAnimation(.spring(duration: 0.35)) { open = true }
                        } label: {
                            HStack {
                                Text(place).font(.system(size: 15, weight: .semibold)).foregroundStyle(Theme.text)
                                Spacer()
                                Image(systemName: "chevron.right").foregroundStyle(Theme.faint)
                            }
                            .padding(.horizontal, 14).frame(height: 46)
                            .background(Theme.fill, in: RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PressStyle())
                        Text("날짜 (iOS 기본 피커)").font(.system(size: 13, weight: .medium)).foregroundStyle(Theme.sub).padding(.top, 6)
                        DatePicker("", selection: .constant(Date()), displayedComponents: .date)
                            .labelsHidden()
                            .datePickerStyle(.compact)
                        Spacer()
                    }
                    .padding(16)

                    if open {
                        Color.black.opacity(0.35)
                            .onTapGesture { withAnimation(.spring(duration: 0.3)) { open = false } }
                            .transition(.opacity)
                        VStack(spacing: 0) {
                            HStack {
                                Button("취소") { withAnimation(.spring(duration: 0.3)) { open = false } }
                                    .foregroundStyle(Theme.sub)
                                Spacer()
                                Text("여행지 선택").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                                Spacer()
                                Button("완료") {
                                    place = temp
                                    Haptic.success()
                                    withAnimation(.spring(duration: 0.3)) { open = false }
                                }
                                .fontWeight(.bold).foregroundStyle(Theme.blue)
                            }
                            .font(.system(size: 15))
                            .padding(.horizontal, 18).frame(height: 48)
                            Picker("여행지", selection: $temp) {
                                ForEach(places, id: \.self) { Text($0).tag($0) }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 170)
                            .clipped()
                        }
                        .padding(.bottom, 10)
                        .background(Theme.card, in: SheetShape())
                        .transition(.move(edge: .bottom))
                    }
                }
            }
            DemoNote(text: open ? "휠을 위아래로 굴려보세요. 가운데 줄에 걸린 값이 선택돼요. (지금: \(temp))" : "‘여행지’를 눌러 피커를 열어보세요.")
        }
    }
}

// MARK: - 플레이스홀더

struct PlaceholderDemo: View {
    @State private var email = ""
    @State private var phone = ""
    @FocusState private var focus: Int?

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 14) {
                    ScreenTitle(text: "로그인")
                    FieldBox(focused: focus == 0) {
                        TextField("woody@mail.com", text: $email)
                            .keyboardType(.emailAddress).textInputAutocapitalization(.never)
                            .focused($focus, equals: 0)
                    }
                    .overlay(alignment: .trailing) {
                        if email.isEmpty {
                            Text("← 플레이스홀더").font(.system(size: 11, weight: .bold)).foregroundStyle(Theme.blue).padding(.trailing, 12)
                        }
                    }
                    FieldBox(focused: focus == 1) {
                        TextField("010-0000-0000", text: $phone)
                            .keyboardType(.numberPad)
                            .focused($focus, equals: 1)
                    }
                    Text(email.isEmpty && phone.isEmpty
                         ? "회색 글씨는 ‘예시’예요. 칸에 입력해 보세요."
                         : "입력하자 회색 예시가 사라졌어요. 이제 이 칸이 무슨 칸이었는지 알 수 있나요?")
                        .font(.system(size: 13)).foregroundStyle(email.isEmpty && phone.isEmpty ? Theme.sub : Theme.red)
                    Spacer()
                    Button("완료") { focus = nil }.buttonStyle(DSButtonStyle())
                }
                .padding(16)
            }
            DemoNote(text: "플레이스홀더는 입력하는 순간 사라져서, 이것만으로는 칸 이름(라벨)을 대신할 수 없어요.")
        }
    }
}

// MARK: - 라벨

struct FloatingField: View {
    let title: String
    @Binding var text: String
    @FocusState private var focused: Bool

    var body: some View {
        let up = focused || !text.isEmpty
        ZStack(alignment: .leading) {
            Text(title)
                .font(.system(size: up ? 11 : 15, weight: up ? .semibold : .regular))
                .foregroundStyle(focused ? Theme.blue : Theme.faint)
                .offset(y: up ? -12 : 0)
            TextField("", text: $text)
                .font(.system(size: 15))
                .focused($focused)
                .offset(y: up ? 8 : 0)
        }
        .padding(.horizontal, 14)
        .frame(height: 56)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(focused ? Theme.blue : Theme.fillStrong, lineWidth: focused ? 2 : 1)
        }
        .animation(.spring(duration: 0.25), value: up)
        .contentShape(Rectangle())
        .onTapGesture { focused = true }
    }
}

struct LabelDemo: View {
    @State private var email = ""
    @State private var name = ""
    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 8) {
                    ScreenTitle(text: "회원 정보").padding(.bottom, 6)
                    HStack(spacing: 6) {
                        Text("이메일").font(.system(size: 13, weight: .semibold)).foregroundStyle(focused ? Theme.blue : Theme.text)
                        Text("← 라벨").font(.system(size: 11, weight: .bold)).foregroundStyle(Theme.blue)
                    }
                    FieldBox(focused: focused) {
                        TextField("woody@mail.com", text: $email)
                            .keyboardType(.emailAddress).textInputAutocapitalization(.never)
                            .focused($focused)
                    }
                    Text("고정 라벨: 입력해도 위에 계속 남아요").font(.system(size: 11)).foregroundStyle(Theme.sub)
                        .padding(.bottom, 14)
                    FloatingField(title: "이름", text: $name)
                    Text("플로팅 라벨: 칸 안에 있다가 입력하면 위로 올라가요").font(.system(size: 11)).foregroundStyle(Theme.sub)
                    Spacer()
                    Button("완료") { focused = false; UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
                        .buttonStyle(DSButtonStyle())
                }
                .padding(16)
            }
            DemoNote(text: email.isEmpty && name.isEmpty ? "두 칸에 각각 입력해보세요." : "입력한 뒤에도 ‘이메일’, ‘이름’이라는 이름표가 남아 있죠? 그게 라벨이에요.")
        }
    }
}

// MARK: - 입력 검증

struct ValidationDemo: View {
    @State private var email = ""
    @State private var password = ""
    @State private var done = false

    private var emailValid: Bool {
        email.range(of: #"^[^@\s]+@[^@\s]+\.[A-Za-z]{2,}$"#, options: .regularExpression) != nil
    }
    private var emailError: Bool { !email.isEmpty && !emailValid }
    private var ruleLength: Bool { password.count >= 8 }
    private var ruleNumber: Bool { password.rangeOfCharacter(from: .decimalDigits) != nil }
    private var ruleLetter: Bool { password.rangeOfCharacter(from: .letters) != nil }
    private var allValid: Bool { emailValid && ruleLength && ruleNumber && ruleLetter }

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame(height: 500) {
                VStack(alignment: .leading, spacing: 8) {
                    ScreenTitle(text: "가입하기").padding(.bottom, 4)
                    Text("이메일").font(.system(size: 13, weight: .semibold)).foregroundStyle(emailError ? Theme.red : Theme.text)
                    FieldBox(error: emailError) {
                        HStack {
                            TextField("woody@mail.com", text: $email)
                                .keyboardType(.emailAddress).textInputAutocapitalization(.never).autocorrectionDisabled()
                            if emailValid { Image(systemName: "checkmark.circle.fill").foregroundStyle(Theme.green) }
                        }
                    }
                    if emailError {
                        Label("이메일 형식이 아니에요", systemImage: "exclamationmark.circle.fill")
                            .font(.system(size: 12, weight: .medium)).foregroundStyle(Theme.red)
                            .transition(.opacity)
                    }
                    Text("비밀번호").font(.system(size: 13, weight: .semibold)).foregroundStyle(Theme.text).padding(.top, 8)
                    FieldBox {
                        SecureField("8자 이상", text: $password)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        rule("8자 이상", ruleLength)
                        rule("영문 포함", ruleLetter)
                        rule("숫자 포함", ruleNumber)
                    }
                    Spacer()
                    Button(done ? "가입 완료 🎉" : "가입하기") { done = true; Haptic.success() }
                        .buttonStyle(DSButtonStyle())
                        .disabled(!allValid)
                        .opacity(allValid ? 1 : 0.4)
                }
                .padding(16)
                .animation(.easeInOut(duration: 0.2), value: emailError)
            }
            DemoNote(text: allValid ? "모든 조건을 만족해서 버튼이 켜졌어요!" : "제출하기 전에, 입력하는 자리에서 바로 맞고 틀림을 알려줘요.")
        }
    }

    private func rule(_ text: String, _ ok: Bool) -> some View {
        HStack(spacing: 6) {
            Image(systemName: ok ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(ok ? Theme.green : Theme.faint)
            Text(text).foregroundStyle(ok ? Theme.green : Theme.sub)
        }
        .font(.system(size: 12, weight: .medium))
        .animation(.spring(duration: 0.25), value: ok)
    }
}

// MARK: - 토글

struct ToggleDemo: View {
    @State private var dark = false
    @State private var big = false
    @State private var notify = true

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 14) {
                    ScreenTitle(text: "설정")
                    // 미리보기
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("미리보기").font(.system(size: big ? 17 : 13, weight: .bold))
                            Spacer()
                            Image(systemName: notify ? "bell.badge.fill" : "bell.slash.fill")
                                .foregroundStyle(notify ? Theme.red : Color.gray)
                        }
                        Text("스위치를 누르는 즉시 바뀌어요").font(.system(size: big ? 16 : 12))
                    }
                    .foregroundStyle(dark ? Color.white : Color(hex: 0x191F28))
                    .padding(14)
                    .background(dark ? Color(hex: 0x1F2329) : Color(hex: 0xF2F4F6), in: RoundedRectangle(cornerRadius: 14))
                    .animation(.easeInOut(duration: 0.25), value: dark)
                    .animation(.easeInOut(duration: 0.25), value: big)

                    VStack(spacing: 0) {
                        row("다크 모드", "moon.fill", $dark)
                        row("큰 글씨", "textformat.size", $big)
                        row("알림 받기", "bell.fill", $notify)
                    }
                    Spacer()
                }
                .padding(16)
            }
            DemoNote(text: "저장 버튼이 없죠? 토글은 누르는 순간 바로 적용돼요.")
        }
    }

    private func row(_ title: String, _ icon: String, _ binding: Binding<Bool>) -> some View {
        Toggle(isOn: binding) {
            Label(title, systemImage: icon).font(.system(size: 15)).foregroundStyle(Theme.text)
        }
        .tint(Theme.blue)
        .frame(height: 50)
        .onChange(of: binding.wrappedValue) { _, _ in Haptic.impact(.light) }
    }
}

// MARK: - 체크박스

struct CheckboxDemo: View {
    @State private var checks = [false, false, false, false]
    private let items = [("서비스 이용약관", true), ("개인정보 수집·이용", true), ("위치정보 이용", false), ("마케팅 수신", false)]
    private var allChecked: Bool { !checks.contains(false) }
    private var requiredOK: Bool { items.indices.allSatisfy { !items[$0].1 || checks[$0] } }

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 12) {
                    ScreenTitle(text: "약관 동의")
                    Button {
                        let target = !allChecked
                        withAnimation { checks = Array(repeating: target, count: checks.count) }
                        Haptic.selection()
                    } label: {
                        HStack(spacing: 12) {
                            CheckMark(on: allChecked)
                            Text("전체 동의").font(.system(size: 16, weight: .bold)).foregroundStyle(Theme.text)
                            Spacer()
                        }
                        .padding(14)
                        .background(Theme.fill, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                    ForEach(items.indices, id: \.self) { i in
                        Button {
                            checks[i].toggle()
                            Haptic.selection()
                        } label: {
                            HStack(spacing: 12) {
                                CheckMark(on: checks[i])
                                Text(items[i].1 ? "[필수]" : "[선택]").font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(items[i].1 ? Theme.blue : Theme.sub)
                                Text(items[i].0).font(.system(size: 14)).foregroundStyle(Theme.text)
                                Spacer()
                            }
                            .padding(.horizontal, 14).frame(height: 36)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                    Button("다음") {}
                        .buttonStyle(DSButtonStyle())
                        .disabled(!requiredOK)
                        .opacity(requiredOK ? 1 : 0.4)
                }
                .padding(16)
            }
            DemoNote(text: "체크박스는 여러 개를 자유롭게 골라요. 지금 \(checks.filter { $0 }.count)개 선택됨. 필수를 다 고르면 ‘다음’이 켜져요.")
        }
    }
}

// MARK: - 라디오

struct RadioDemo: View {
    @State private var selected = 0
    private let options = [("일반 배송", "2~3일 · 무료", 0), ("빠른 배송", "내일 도착 · 3,000원", 3000), ("새벽 배송", "내일 아침 7시 전 · 5,000원", 5000)]

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 12) {
                    ScreenTitle(text: "배송 방법")
                    ForEach(options.indices, id: \.self) { i in
                        Button {
                            selected = i
                            Haptic.selection()
                        } label: {
                            HStack(spacing: 12) {
                                CheckMark(on: selected == i, round: true)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(options[i].0).font(.system(size: 15, weight: .semibold)).foregroundStyle(Theme.text)
                                    Text(options[i].1).font(.system(size: 12)).foregroundStyle(Theme.sub)
                                }
                                Spacer()
                            }
                            .padding(14)
                            .background(selected == i ? Theme.blueSoft : Theme.fill, in: RoundedRectangle(cornerRadius: 14))
                            .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(selected == i ? Theme.blue : Color.clear, lineWidth: 1.5))
                        }
                        .buttonStyle(.plain)
                        .animation(.spring(duration: 0.25), value: selected)
                    }
                    Spacer()
                    HStack {
                        Text("총 결제 금액").font(.system(size: 14)).foregroundStyle(Theme.sub)
                        Spacer()
                        Text("\(29000 + options[selected].2)원").font(.system(size: 17, weight: .bold)).foregroundStyle(Theme.text)
                            .contentTransition(.numericText())
                            .animation(.spring, value: selected)
                    }
                }
                .padding(16)
            }
            DemoNote(text: "라디오 버튼은 그룹 안에서 반드시 하나만 켜져요. 다른 걸 누르면 이전 선택이 꺼져요.")
        }
    }
}

// MARK: - 세그먼트 컨트롤

struct SegmentedDemo: View {
    @State private var period = 0
    private let periods = ["일간", "주간", "월간"]
    private let data: [[Double]] = [
        [0.3, 0.5, 0.8, 0.4, 0.6, 0.9, 0.7],
        [0.6, 0.4, 0.7, 0.9],
        [0.5, 0.7, 0.4, 0.8, 0.6, 0.9],
    ]
    private let labels = [["월", "화", "수", "목", "금", "토", "일"], ["1주", "2주", "3주", "4주"], ["6월", "7월", "8월", "9월", "10월", "11월"]]
    private let totals = ["8,412", "52,310", "231,904"]

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 16) {
                    ScreenTitle(text: "걸음 수")
                    Picker("기간", selection: $period.animation(.spring(duration: 0.4))) {
                        ForEach(periods.indices, id: \.self) { Text(periods[$0]).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(periods[period] + " 합계").font(.system(size: 13)).foregroundStyle(Theme.sub)
                        Text(totals[period] + "걸음").font(.system(size: 26, weight: .bold)).foregroundStyle(Theme.text)
                            .contentTransition(.numericText())
                    }
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(data[period].indices, id: \.self) { i in
                            VStack(spacing: 6) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(i == data[period].count - 1 ? Theme.blue : Theme.blue.opacity(0.3))
                                    .frame(height: 160 * data[period][i])
                                Text(labels[period][i]).font(.system(size: 10)).foregroundStyle(Theme.sub)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 190, alignment: .bottom)
                    .id(period)
                    .transition(.opacity)
                    Spacer(minLength: 0)
                }
                .padding(16)
            }
            DemoNote(text: "세그먼트를 바꿔도 화면은 그대로, 아래 내용(보기)만 바뀌어요.")
        }
    }
}

// MARK: - 칩

struct ChipDemo: View {
    @State private var filters: Set<String> = []
    @State private var tags: [String] = ["디자인", "iOS"]
    @State private var input = ""
    private let categories = ["카페", "맛집", "디저트", "술집"]
    private let places = [("블루보틀", "카페"), ("을지로 노가리", "술집"), ("성수 베이커리", "디저트"), ("진진 중식당", "맛집"), ("연남 카페", "카페"), ("마카롱 가게", "디저트")]

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame(height: 520) {
                VStack(alignment: .leading, spacing: 12) {
                    ScreenTitle(text: "주변 장소")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            chip("전체", on: filters.isEmpty) { filters = [] }
                            ForEach(categories, id: \.self) { c in
                                chip(c, on: filters.contains(c)) {
                                    if filters.contains(c) { filters.remove(c) } else { filters.insert(c) }
                                }
                            }
                        }
                    }
                    let shown = places.indices.filter { filters.isEmpty || filters.contains(places[$0].1) }
                    VStack(spacing: 8) {
                        ForEach(shown, id: \.self) { idx in
                            MockRow(index: categories.firstIndex(of: places[idx].1) ?? 0, title: places[idx].0, subtitle: places[idx].1)
                        }
                    }
                    .animation(.spring(duration: 0.3), value: filters)

                    Divider().padding(.vertical, 4)
                    Text("입력 칩 (태그)").font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.sub)
                    FlowTags(tags: $tags)
                    FieldBox {
                        TextField("태그 입력 후 엔터", text: $input)
                            .onSubmit {
                                let t = input.trimmingCharacters(in: .whitespaces)
                                if !t.isEmpty && !tags.contains(t) { withAnimation { tags.append(t) } }
                                input = ""
                            }
                    }
                    Spacer(minLength: 0)
                }
                .padding(16)
            }
            DemoNote(text: filters.isEmpty ? "위쪽 필터 칩을 여러 개 눌러보세요. 동시에 켤 수 있어요." : "\(filters.sorted().joined(separator: ", ")) 칩이 켜졌어요.")
        }
    }

    private func chip(_ title: String, on: Bool, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation(.spring(duration: 0.25)) { action() }
            Haptic.selection()
        } label: {
            HStack(spacing: 4) {
                if on && title != "전체" { Image(systemName: "checkmark").font(.system(size: 10, weight: .bold)) }
                Text(title)
            }
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(on ? Color.white : Theme.text)
            .padding(.horizontal, 12).frame(height: 32)
            .background(on ? Theme.blue : Theme.fill, in: Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct FlowTags: View {
    @Binding var tags: [String]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(tags, id: \.self) { t in
                    HStack(spacing: 4) {
                        Text("#" + t)
                        Button { withAnimation { tags.removeAll { $0 == t } } } label: {
                            Image(systemName: "xmark").font(.system(size: 9, weight: .bold))
                        }
                    }
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Theme.blue)
                    .padding(.horizontal, 10).frame(height: 30)
                    .background(Theme.blueSoft, in: Capsule())
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
}

// MARK: - 슬라이더

struct SliderDemo: View {
    @State private var price: Double = 50000
    @State private var brightness: Double = 0.7

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 18) {
                    ScreenTitle(text: "필터")
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("최대 가격").font(.system(size: 14, weight: .semibold)).foregroundStyle(Theme.text)
                            Spacer()
                            Text("\(Int(price / 1000) * 1000)원").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.blue).monospacedDigit()
                        }
                        Slider(value: $price, in: 0...100000).tint(Theme.blue)
                        HStack { Text("0원"); Spacer(); Text("10만원") }.font(.system(size: 11)).foregroundStyle(Theme.sub)
                        Text("\(max(0, Int(price / 8000))) 개의 상품").font(.system(size: 12)).foregroundStyle(Theme.sub)
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("사진 밝기").font(.system(size: 14, weight: .semibold)).foregroundStyle(Theme.text)
                        HStack {
                            Image(systemName: "sun.min").foregroundStyle(Theme.sub)
                            Slider(value: $brightness, in: 0...1).tint(Theme.orange)
                            Image(systemName: "sun.max.fill").foregroundStyle(Theme.orange)
                        }
                        RoundedRectangle(cornerRadius: 14)
                            .fill(LinearGradient(colors: [Color(hex: 0xFF8A5B), Color(hex: 0x8B5CF6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .overlay(Image(systemName: "mountain.2.fill").font(.system(size: 40)).foregroundStyle(.white))
                            .brightness(brightness - 0.7)
                            .frame(height: 110)
                    }
                    Spacer(minLength: 0)
                }
                .padding(16)
            }
            DemoNote(text: "손잡이를 끄는 동안 값이 계속 바뀌어요. ‘대충 이 정도’를 빠르게 고를 때 좋아요.")
        }
    }
}

// MARK: - 수량 스테퍼

struct StepperDemo: View {
    @State private var qty = 1
    @State private var people = 2
    private let unit = 12900

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 16) {
                    ScreenTitle(text: "장바구니")
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 12).fill(Theme.pastel(0)).frame(width: 64, height: 64)
                            .overlay(Text("🍰").font(.system(size: 30)))
                        VStack(alignment: .leading, spacing: 6) {
                            Text("딸기 케이크").font(.system(size: 15, weight: .semibold)).foregroundStyle(Theme.text)
                            Text("12,900원").font(.system(size: 13)).foregroundStyle(Theme.sub)
                            HStack(spacing: 0) {
                                stepButton("minus", disabled: qty <= 1) { qty -= 1 }
                                Text("\(qty)").font(.system(size: 15, weight: .bold)).frame(width: 36).monospacedDigit()
                                    .contentTransition(.numericText())
                                stepButton("plus", disabled: qty >= 10) { qty += 1 }
                            }
                            .background(Theme.fill, in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    Divider()
                    Stepper("함께 먹을 인원: \(people)명", value: $people, in: 1...8)
                        .font(.system(size: 14))
                    Text("↑ iOS 기본 스테퍼").font(.system(size: 11)).foregroundStyle(Theme.sub)
                    Spacer()
                    HStack {
                        Text("합계").foregroundStyle(Theme.sub)
                        Spacer()
                        Text("\(qty * unit)원").font(.system(size: 20, weight: .bold)).foregroundStyle(Theme.text)
                            .contentTransition(.numericText())
                    }
                }
                .padding(16)
                .animation(.spring(duration: 0.3), value: qty)
            }
            DemoNote(text: qty >= 10 ? "최대 10개예요. ＋ 버튼이 비활성화됐어요." : (qty <= 1 ? "1개 아래로는 내려갈 수 없어서 － 가 꺼져 있어요." : "한 번에 정확히 1씩 바뀌어요."))
        }
    }

    private func stepButton(_ icon: String, disabled: Bool, action: @escaping () -> Void) -> some View {
        Button {
            action()
            Haptic.selection()
        } label: {
            Image(systemName: icon).font(.system(size: 13, weight: .bold))
                .foregroundStyle(disabled ? Theme.faint : Theme.text)
                .frame(width: 34, height: 34)
        }
        .disabled(disabled)
    }
}

// MARK: - 검색창

struct SearchBarDemo: View {
    @State private var query = ""
    @FocusState private var focused: Bool
    @State private var recents = ["라떼", "샌드위치", "케이크"]
    private let menu = ["아메리카노", "카페 라떼", "바닐라 라떼", "라면", "샌드위치", "치즈 케이크", "딸기 케이크", "레몬에이드", "녹차 라떼", "크로와상"]

    var body: some View {
        VStack(spacing: 14) {
            PhoneFrame {
                VStack(alignment: .leading, spacing: 12) {
                    if !focused { ScreenTitle(text: "메뉴") }
                    HStack(spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: "magnifyingglass").foregroundStyle(Theme.sub)
                            TextField("메뉴 검색", text: $query).focused($focused)
                            if !query.isEmpty {
                                Button { query = "" } label: { Image(systemName: "xmark.circle.fill").foregroundStyle(Theme.faint) }
                            }
                        }
                        .font(.system(size: 15))
                        .padding(.horizontal, 12).frame(height: 40)
                        .background(Theme.fill, in: RoundedRectangle(cornerRadius: 12))
                        if focused {
                            Button("취소") { query = ""; focused = false }
                                .font(.system(size: 15)).foregroundStyle(Theme.blue)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                        }
                    }
                    if focused && query.isEmpty {
                        Text("최근 검색어").font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.sub)
                        HStack(spacing: 6) {
                            ForEach(recents, id: \.self) { r in
                                Button(r) { query = r }
                                    .font(.system(size: 13)).foregroundStyle(Theme.text)
                                    .padding(.horizontal, 10).frame(height: 28)
                                    .background(Theme.fill, in: Capsule())
                            }
                        }
                    } else {
                        let results = query.isEmpty ? menu : menu.filter { $0.contains(query) }
                        if results.isEmpty {
                            Text("‘\(query)’ 검색 결과가 없어요").font(.system(size: 14)).foregroundStyle(Theme.sub).padding(.top, 20).frame(maxWidth: .infinity)
                        }
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(results, id: \.self) { m in
                                    highlighted(m)
                                        .font(.system(size: 15))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .frame(height: 40)
                                }
                            }
                        }
                    }
                    Spacer(minLength: 0)
                }
                .padding(16)
                .animation(.spring(duration: 0.3), value: focused)
            }
            DemoNote(text: query.isEmpty ? "검색창을 눌러보세요. 최근 검색어가 먼저 보여요." : "입력하는 대로 결과가 걸러지고, 일치하는 글자가 파랗게 강조돼요.")
        }
    }

    private func highlighted(_ text: String) -> Text {
        guard !query.isEmpty, let r = text.range(of: query) else { return Text(text).foregroundColor(Theme.text) }
        return Text(String(text[..<r.lowerBound])).foregroundColor(Theme.text)
            + Text(String(text[r])).foregroundColor(Theme.blue).bold()
            + Text(String(text[r.upperBound...])).foregroundColor(Theme.text)
    }
}
