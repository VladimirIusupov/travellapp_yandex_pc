import SwiftUI
import Combine

final class AppAlerts: ObservableObject {
    @Published var showNoInternet: Bool = false
    @Published var showServerError: Bool = false
    @Published var serverErrorMessage: String = "Что-то пошло не так"

    func presentNoInternet() { showNoInternet = true }
    func presentServerError(_ message: String) {
        serverErrorMessage = message
        showServerError = true
    }
}
