import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - Typealiases
typealias StationSchedule = Components.Schemas.ScheduleResponse

// MARK: - Protocol
protocol StationScheduleServiceProtocol {
    func getStationSchedule(station: String) async throws -> StationSchedule
}

// MARK: - Service
final class StationScheduleService: StationScheduleServiceProtocol {
    
    // MARK: - Private Properties
    private let client: Client
    private let apikey: String
    
    // MARK: - Init
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    // MARK: - Public Methods
    func getStationSchedule(station: String) async throws -> StationSchedule {
        let today = ISO8601DateFormatter().string(from: Date()).prefix(10)
        
        let response = try await client.getStationSchedule(query: .init(
            apikey: apikey,
            station: station,
            format: "json",
            date: String(today),
            transport_types: "train"
        ))
        
        guard case let .ok(okResponse) = response else {
            throw URLError(.badServerResponse)
        }
        
        return try response.ok.body.json
    }
}
