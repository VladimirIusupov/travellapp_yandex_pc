import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - Typealiases
typealias SearchResponse = Components.Schemas.Segments

// MARK: - Protocol
protocol SearchServiceProtocol {
    func getSchedule(from: String, to: String) async throws -> SearchResponse
}

// MARK: - Service
final class SearchService: SearchServiceProtocol {
    
    // MARK: - Private Properties
    private let client: Client
    private let apikey: String
    
    // MARK: - Init
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    // MARK: - Public Methods
    func getSchedule(from: String, to: String) async throws -> SearchResponse {
        let today = ISO8601DateFormatter().string(from: Date()).prefix(10)
        
        let response = try await client.getSchedualBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            format: "json",
            date: String(today),
            transport_types: "train"
        ))
        
        guard case let .ok(okResponse) = response else {
            throw URLError(.badServerResponse)
        }
        
        let json = try okResponse.body.json
        print(" RAW SearchResponse: \(json)")
        return json
    }
}
