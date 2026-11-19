import SwiftUI

@main
struct LearnUIApp: App {
    @StateObject private var progress = ProgressStore()

    init() {
        NotificationManager.shared.setup()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(progress)
                .tint(Theme.blue)
        }
    }
}

struct RootView: View {
    @State private var tab = 0

    var body: some View {
        TabView(selection: $tab) {
            HomeView()
                .tabItem { Label("개념", systemImage: "square.grid.2x2.fill") }
                .tag(0)
            CompareListView()
                .tabItem { Label("짝 비교", systemImage: "arrow.left.arrow.right.square.fill") }
                .tag(1)
            QuizView()
                .tabItem { Label("퀴즈", systemImage: "checkmark.seal.fill") }
                .tag(2)
        }
    }
}
