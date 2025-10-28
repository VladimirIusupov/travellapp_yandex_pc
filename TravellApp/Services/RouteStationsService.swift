import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - Typealiases
typealias RouteStations = Components.Schemas.ThreadStationsResponse

// MARK: - Protocol
protocol RouteStationsServiceProtocol {
    func getRouteStations(stationCode: String) async throws -> RouteStations
    func getRouteStationsRaw(uid: String) async throws -> RouteStations
}

// MARK: - Service
final class RouteStationsService: RouteStationsServiceProtocol {
    
    // MARK: - Private Properties
    private let client: Client
    private let apikey: String
    private let stationScheduleService: StationScheduleServiceProtocol
    
    // MARK: - Init
    init(client: Client, apikey: String, stationScheduleService: StationScheduleServiceProtocol) {
        self.client = client
        self.apikey = apikey
        self.stationScheduleService = stationScheduleService
    }
    
    // MARK: - Public Methods
    func getRouteStations(stationCode: String) async throws -> RouteStations {
        let scheduleResponse = try await stationScheduleService.getStationSchedule(station: stationCode)
        
        guard let firstUID = scheduleResponse.schedule?.first?.thread?.uid else {
            throw URLError(.badServerResponse)
        }
        
        print("UID найден:", firstUID)
        return try await getRouteStationsRaw(uid: firstUID)
    }
    
    func getRouteStationsRaw(uid: String) async throws -> RouteStations {
        var components = URLComponents(string: "https://api.rasp.yandex.net/v3.0/thread/")!
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apikey),
            URLQueryItem(name: "uid", value: uid)
        ]
        
        let (data, _) = try await URLSession.shared.data(from: components.url!)
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print(" RAW JSON:\n\(jsonString)")
        }
        
        return try RouteStationsServiceDateDecoder.decoder.decode(RouteStations.self, from: data)
    }
}
