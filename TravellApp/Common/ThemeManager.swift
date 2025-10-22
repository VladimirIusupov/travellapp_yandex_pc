import SwiftUI
import Combine

final class ThemeManager: ObservableObject {
    @AppStorage("isDarkTheme") var isDarkTheme: Bool = false {
        didSet { objectWillChange.send() }
    }
}
