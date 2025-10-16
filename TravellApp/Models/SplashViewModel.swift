import Foundation

final class SplashViewModel: ObservableObject {
    @Published var showProgress: Bool = false
    @Published var didFinish: Bool = false

    @MainActor
    func onAppear() async {
        showProgress = false
        // TODO: здесь позже будет реальная инициализация (прелоад API/кеша и т.д.)
        try? await Task.sleep(nanoseconds: 800_000_000)
        didFinish = true
    }
}
