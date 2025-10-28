import SwiftUI

// MARK: - ViewModel
@MainActor
final class CarriersViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var carrier: Components.Schemas.Carrier?
    @Published var isLoading = false
    @Published var appError: AppError?
    
    // MARK: - Public Methods
    func loadCarrier(code: String) async {
        isLoading = true
        appError = nil
        
        do {
            let response = try await NetworkClient.shared.fetchCarrier(code: code)
            
            print(" CarrierResponse: \(response)")
            
            if let array = response.carriers, !array.isEmpty {
                self.carrier = array.first
            } else {
                
                if let data = try? JSONEncoder().encode(response),
                   let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let carrierDict = dict["carrier"] as? [String: Any],
                   let carrierData = try? JSONSerialization.data(withJSONObject: carrierDict),
                   let carrierObj = try? JSONDecoder().decode(Components.Schemas.Carrier.self, from: carrierData) {
                    self.carrier = carrierObj
                }
            }
            
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
        
        isLoading = false
    }
}
