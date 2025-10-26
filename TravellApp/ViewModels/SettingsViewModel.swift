import Foundation
import SwiftUI

// MARK: - ViewModel
@MainActor
final class SettingsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var appError: AppError?
    @Published var showAgreement: Bool = false
    
    @AppStorage("appTheme") private var appTheme: String = AppTheme.light.rawValue
    
    // MARK: - Computed Properties
    var isDarkMode: Binding<Bool> {
        Binding(
            get: { self.appTheme == AppTheme.dark.rawValue },
            set: { self.appTheme = $0 ? AppTheme.dark.rawValue : AppTheme.light.rawValue }
        )
    }
    
    // MARK: - Public Methods
    func openAgreement() {
        showAgreement = true
    }
    
    func loadSettings() async {
        isLoading = true
        appError = nil
        
        defer { isLoading = false }
        
        do {
            
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                appError = .noInternet
            case .badServerResponse, .cannotConnectToHost:
                appError = .serverError
            default:
                appError = .unknown
            }
        } catch {
            appError = .unknown
        }
    }
}
