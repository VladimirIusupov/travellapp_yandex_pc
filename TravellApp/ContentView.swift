import SwiftUI

final class AppState: ObservableObject {
    enum Phase { case splash, tabs }
    @Published var phase: Phase = .splash
}

struct ContentView: View {
    @StateObject private var appState = AppState()
    @StateObject private var splashVM = SplashViewModel()

    // читаем глобальную настройку темы
    @AppStorage("isDarkTheme") private var isDarkTheme: Bool = false

    var body: some View {
        ZStack {
            switch appState.phase {
            case .splash:
                SplashView(viewModel: splashVM)
                    .onReceive(splashVM.$didFinish) { finished in
                        guard finished else { return }
                        withAnimation(.easeInOut(duration: 0.35)) {
                            appState.phase = .tabs
                        }
                    }
                    .transition(.opacity)
            case .tabs:
                MainTabView()
                    .transition(.opacity)
            }
        }
        // применяем тему ко всему приложению
        .preferredColorScheme(isDarkTheme ? .dark : .light)
    }
}

#Preview { ContentView() }
