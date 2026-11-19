import SwiftUI

/// 개념 id → 실제로 눌러볼 수 있는 데모
struct DemoView: View {
    let id: String

    var body: some View {
        content
            .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var content: some View {
        switch id {
        // 알림·오버레이
        case "popup": PopupDemo()
        case "modal": ModalDemo()
        case "alert": AlertDemo()
        case "confirm": ConfirmDemo()
        case "actionSheet": ActionSheetDemo()
        case "toast": ToastDemo()
        case "snackbar": SnackbarDemo()
        case "tooltip": TooltipDemo()
        case "popover": PopoverDemo()
        case "bottomSheet": BottomSheetDemo()
        case "drawer": DrawerPhone()
        case "banner": BannerDemo()
        case "push": PushDemo()
        case "contextMenu": ContextMenuDemo()
        case "dim": DimDemo()
        case "blur": BlurDemo()
        // 상태·피드백
        case "badge": BadgeDemo()
        case "dot": DotDemo()
        case "progressBar": ProgressBarDemo()
        case "steps": StepsDemo()
        case "spinner": SpinnerDemo()
        case "skeleton": SkeletonDemo()
        case "emptyState": EmptyStateDemo()
        case "pullToRefresh": PullToRefreshDemo()
        case "haptic": HapticDemo()
        case "onboarding": OnboardingDemo()
        case "coachMark": CoachMarkDemo()
        // 입력·선택
        case "dropdown": DropdownDemo()
        case "picker": PickerDemo()
        case "placeholder": PlaceholderDemo()
        case "label": LabelDemo()
        case "validation": ValidationDemo()
        case "toggle": ToggleDemo()
        case "checkbox": CheckboxDemo()
        case "radio": RadioDemo()
        case "segmented": SegmentedDemo()
        case "chip": ChipDemo()
        case "slider": SliderDemo()
        case "stepper": StepperDemo()
        case "searchBar": SearchBarDemo()
        // 이동·레이아웃
        case "topBar": TopBarDemo()
        case "tabBar": TabBarDemo()
        case "carousel": CarouselDemo()
        case "horizontalScroll": HorizontalScrollDemo()
        case "paging": PagingDemo()
        case "infiniteScroll": InfiniteScrollDemo()
        case "fab": FABDemo()
        case "stickyButton": StickyButtonDemo()
        case "accordion": AccordionDemo()
        case "showMore": ShowMoreDemo()
        case "swipeActions": SwipeActionsDemo()
        // 아이콘
        case "hamburger": DrawerPhone(highlightIcon: true)
        case "kebab": KebabDemo()
        case "meatballs": MeatballsDemo()
        case "heart": HeartDemo()
        case "bookmark": BookmarkDemo()
        case "share": ShareDemo()
        case "export": ExportDemo()
        case "close": CloseDemo()
        case "back": BackDemo()
        case "refresh": RefreshDemo()
        case "undo": UndoDemo()
        case "search": SearchIconDemo()
        case "zoomIn": ZoomInDemo()
        case "filter": FilterDemo()
        case "sort": SortDemo()
        case "edit": EditDemo()
        case "compose": ComposeDemo()
        default:
            Text("준비 중이에요").foregroundStyle(Theme.sub)
        }
    }
}
