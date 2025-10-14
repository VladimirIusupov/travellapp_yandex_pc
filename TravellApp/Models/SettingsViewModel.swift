import Foundation

final class SettingsViewModel: ObservableObject {
    @Published var isDarkTheme: Bool {
        didSet { UserDefaults.standard.set(isDarkTheme, forKey: "isDarkTheme") }
    }

    init() {
        self.isDarkTheme = UserDefaults.standard.bool(forKey: "isDarkTheme")
    }
}
