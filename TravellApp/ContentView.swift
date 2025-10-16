import SwiftUI

final class AppState: ObservableObject {
    enum Phase { case splash, tabs }
    @Published var phase: Phase = .splash
}

struct ContentView: View {
    @StateObject private var appState = AppState()
    @StateObject private var splashVM = SplashViewModel()

    // Глобальные алерты и монитор сети
    @StateObject private var appAlerts = AppAlerts()
    @StateObject private var network = NetworkMonitor()

    // API-клиент (адаптер поверх сгенерированного)
    private let api = SchedulesAPIClient()
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
            case .tabs:
                MainTabView()
                    .environmentObject(appAlerts)
                    .environmentObject(network)
                    .environment(\.schedulesAPI, api)
            }
        }
        // Глобальный показ «Нет интернета»
        .sheet(isPresented: $appAlerts.showNoInternet) {
            NoInternetView()                    
        }
        // Глобальный показ «Ошибка сервера»
        .sheet(isPresented: $appAlerts.showServerError) {
            ServerErrorView()
        }
        .environmentObject(appAlerts)
        // Сообщаем API где искать AppAlerts (для репортинга ошибок)
        .onAppear {
            _ = SchedulesAPIClient(appAlerts: appAlerts)
        }
    }
}


#Preview { ContentView() }
