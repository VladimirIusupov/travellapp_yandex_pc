import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - Typealiases
typealias CopyrightInfo = Components.Schemas.CopyrightResponse

// MARK: - Protocol
protocol CopyrightServiceProtocol {
    func getCopyright() async throws -> CopyrightInfo
}

// MARK: - Service
final class CopyrightService: CopyrightServiceProtocol {
    
    // MARK: - Private Properties
    private let client: Client
    private let apikey: String
    
    // MARK: - Init
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    // MARK: - Public Methods
    func getCopyright() async throws -> CopyrightInfo {
        let response = try await client.getCopyright(query: .init(apikey: apikey))
        return try response.ok.body.json
    }
}
