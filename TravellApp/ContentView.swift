import SwiftUI

final class AppState: ObservableObject {
    enum Phase { case splash, tabs }
    @Published var phase: Phase = .tabs
}

struct ContentView: View {
    @StateObject private var appState   = AppState()
    @StateObject private var theme      = ThemeManager()
    @StateObject private var appAlerts  = AppAlerts()

    var body: some View {
        Group {
            switch appState.phase {
            case .tabs:
                MainTabView()                       
                    .environmentObject(theme)       // <— пробрасываем тему
                    .environmentObject(appAlerts)
            case .splash:
                SplashView(viewModel: .init())
            }
        }
        .preferredColorScheme(theme.isDarkTheme ? .dark : .light) // <— только по свитчу
        // sheets для ошибок (если используешь AppAlerts)
        .sheet(isPresented: $appAlerts.showNoInternet) { NoInternetView() }
        .sheet(isPresented: $appAlerts.showServerError) {
            ServerErrorView(message: appAlerts.serverErrorMessage)
        }
        .onAppear { _ = SchedulesAPIClient(appAlerts: appAlerts) }
    }
}
