import Foundation
import OpenAPIURLSession

// MARK: - Network Client
actor NetworkClient {
    
    // MARK: - Shared
    static let shared = NetworkClient()
    
    // MARK: - Private Properties
    private let client: Client
    private let apiKey: String
    
    // MARK: - Init
    private init() {
        self.apiKey = Config.yandexAPIKey
        self.client = Client(
            serverURL: URL(string: "https://api.rasp.yandex.net")!,
            transport: URLSessionTransport()
        )
    }
    
    // MARK: - Public Methods
    func fetchSchedule(from: String, to: String) async throws -> SearchResponse {
        let service = SearchService(client: client, apikey: apiKey)
        return try await service.getSchedule(from: from, to: to)
    }
    
    func fetchCarrier(code: String) async throws -> CarrierInfo {
        let service = CarrierInfoService(client: client, apikey: apiKey)
        return try await service.getCarrierInfo(code: code)
    }
    
    func fetchAllStations() async throws -> AllStations {
        let service = AllStationsService(client: client, apikey: apiKey)
        return try await service.getAllStations()
    }
    
    func fetchNearestCity(lat: Double, lng: Double) async throws -> NearestCity {
        let service = NearestCityService(client: client, apikey: apiKey)
        return try await service.getNearestCity(lat: lat, lng: lng)
    }
    
    func fetchNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations {
        let service = NearestStationsService(client: client, apikey: apiKey)
        return try await service.getNearestStations(lat: lat, lng: lng, distance: distance)
    }
    
    func fetchStationSchedule(station: String) async throws -> StationSchedule {
        let service = StationScheduleService(client: client, apikey: apiKey)
        return try await service.getStationSchedule(station: station)
    }
    
    func fetchCopyright() async throws -> CopyrightInfo {
        let service = CopyrightService(client: client, apikey: apiKey)
        return try await service.getCopyright()
    }
}
