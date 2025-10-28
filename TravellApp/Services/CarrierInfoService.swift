import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - Typealiases
typealias CarrierInfo = Components.Schemas.CarrierResponse

// MARK: - Protocol
protocol CarrierInfoServiceProtocol {
    func getCarrierInfo(code: String) async throws -> CarrierInfo
}

// MARK: - Service
final class CarrierInfoService: CarrierInfoServiceProtocol {
    
    // MARK: - Private Properties
    private let client: Client
    private let apikey: String
    
    // MARK: - Init
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    // MARK: - Public Methods
    func getCarrierInfo(code: String) async throws -> CarrierInfo {
        let response = try await client.getCarrierInfo(query: .init(
            apikey: apikey,
            code: code
        ))
        
        return try response.ok.body.json
    }
}
