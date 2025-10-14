import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - Typealiases for OpenAPI Models
typealias ScheduleResponse = Components.Schemas.ScheduleResponse
typealias StationScheduleResponse = Components.Schemas.StationScheduleResponse
typealias ThreadStationsResponse = Components.Schemas.ThreadStationsResponse
typealias NearestStationsResponse = Components.Schemas.NearestStationsResponse
typealias NearestSettlementResponse = Components.Schemas.NearestSettlementResponse
typealias StationsListResponse = Components.Schemas.StationsListResponse
typealias CarrierInfoResponse = Components.Schemas.CarrierInfoResponse
typealias CopyrightResponse = Components.Schemas.CopyrightResponse

// MARK: - API Error
enum APIError: LocalizedError {
    case invalidResponse
    case unauthorized
    case notFound
    case serverError(Int)
    case networkError(Error)
    case decodingError(Error)
    case other(statusCode: Int?)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Неверный формат ответа сервера."
        case .unauthorized:
            return "Ошибка авторизации. Проверьте API ключ."
        case .notFound:
            return "Данные не найдены."
        case .serverError(let code):
            return "Ошибка сервера (\(code))."
        case .networkError(let err):
            return "Ошибка сети: \(err.localizedDescription)"
        case .decodingError(let err):
            return "Ошибка при разборе данных: \(err.localizedDescription)"
        case .other(let code):
            return "Неизвестная ошибка (\(code.map(String.init) ?? "n/a"))."
        }
    }
}

// MARK: - Simple Async Cache
actor AsyncCache {
    private var storage: [String: (value: Any, expiry: Date)] = [:]

    func get<T>(_ key: String, as type: T.Type) -> T? {
        guard let entry = storage[key],
              entry.expiry > Date(),
              let value = entry.value as? T else {
            storage.removeValue(forKey: key)
            return nil
        }
        return value
    }

    func set<T>(_ key: String, value: T, ttl: TimeInterval) {
        storage[key] = (value, Date().addingTimeInterval(ttl))
    }
}

// MARK: - Yandex Rasp Service
@MainActor
final class YandexRaspService: ObservableObject {
    private let apiKey: String
    private let client: Client
    private let cache = AsyncCache()
    private let logger = Logger()

    private typealias Ops = Operations

    init(apiKey: String) {
        self.apiKey = apiKey
        self.client = Client(
            serverURL: URL(string: "https://api.rasp.yandex.net/v3.0")!,
            transport: URLSessionTransport()
        )
    }

    // MARK: - Helper Methods

    private func logRequest(_ name: String, parameters: [String: Any]) {
        logger.info("🚀 Request: \(name), params: \(parameters)")
    }

    private func logResponse(_ name: String, success: Bool, details: String = "") {
        logger.info("\(success ? "✅" : "❌") \(name) \(details)")
    }

    private func handleOperation<T>(
        name: String,
        operation: @escaping () async throws -> T
    ) async throws -> T {
        do {
            let result = try await operation()
            logResponse(name, success: true)
            return result
        } catch {
            logResponse(name, success: false, details: error.localizedDescription)
            throw error
        }
    }

    private func mapStatusToError(_ status: Int?) -> APIError {
        switch status {
        case 401: return .unauthorized
        case 404: return .notFound
        case let code? where code >= 500: return .serverError(code)
        default: return .other(statusCode: status)
        }
    }

    // MARK: - API Calls

    func getSchedule(from: String, to: String) async throws -> ScheduleResponse {
        logRequest("getSchedule", parameters: ["from": from, "to": to])
        return try await handleOperation(name: "getSchedule") { [self] in
            let input = Ops.getSchedule.Input(query: .init(
                apikey: self.apiKey,
                from: from,
                to: to,
                lang: nil,
                transport_types: nil,
                limit: nil
            ))
            let result = try await self.client.getSchedule(input)
            switch result {
            case .ok(let ok):
                if case let .json(model) = ok.body { return model }
                else { throw APIError.invalidResponse }
            case .undocumented(let statusCode, _):
                throw self.mapStatusToError(statusCode)
            }
        }
    }

    func getStationSchedule(station: String) async throws -> StationScheduleResponse {
        logRequest("getStationSchedule", parameters: ["station": station])
        return try await handleOperation(name: "getStationSchedule") { [self] in
            let input = Ops.getStationSchedule.Input(query: .init(
                apikey: self.apiKey,
                station: station,
                lang: nil,
                format: nil,
                date: nil,
                limit: nil
            ))
            let result = try await self.client.getStationSchedule(input)
            switch result {
            case .ok(let ok):
                if case let .json(model) = ok.body { return model }
                else { throw APIError.invalidResponse }
            case .undocumented(let statusCode, _):
                throw self.mapStatusToError(statusCode)
            }
        }
    }

    func getNearestStations(lat: Double, lng: Double, distance: Int = 50) async throws -> NearestStationsResponse {
        logRequest("getNearestStations", parameters: ["lat": lat, "lng": lng, "distance": distance])
        return try await handleOperation(name: "getNearestStations") { [self] in
            let input = Ops.getNearestStations.Input(query: .init(
                apikey: self.apiKey,
                lat: lat,
                lng: lng,
                distance: distance,
                limit: nil,
                lang: nil,
                format: nil
            ))
            let result = try await self.client.getNearestStations(input)
            switch result {
            case .ok(let ok):
                if case let .json(model) = ok.body { return model }
                else { throw APIError.invalidResponse }
            case .undocumented(let statusCode, _):
                throw self.mapStatusToError(statusCode)
            }
        }
    }

    func getNearestSettlement(lat: Double, lng: Double) async throws -> NearestSettlementResponse {
        logRequest("getNearestSettlement", parameters: ["lat": lat, "lng": lng])
        return try await handleOperation(name: "getNearestSettlement") { [self] in
            let input = Ops.getNearestSettlement.Input(query: .init(
                apikey: self.apiKey,
                lat: lat,
                lng: lng,
                distance: nil,
                lang: nil,
                format: nil,
                limit: nil
            ))
            let result = try await self.client.getNearestSettlement(input)
            switch result {
            case .ok(let ok):
                if case let .json(model) = ok.body { return model }
                else { throw APIError.invalidResponse }
            case .undocumented(let statusCode, _):
                throw self.mapStatusToError(statusCode)
            }
        }
    }

    func getStationsList() async throws -> StationsListResponse {
        let cacheKey = "stationsList"
        if let cached: StationsListResponse = await cache.get(cacheKey, as: StationsListResponse.self) {
            logResponse("getStationsList", success: true, details: "from cache")
            return cached
        }

        logRequest("getStationsList", parameters: [:])
        return try await handleOperation(name: "getStationsList") { [self] in
            let input = Ops.getStationsList.Input(query: .init(
                apikey: self.apiKey,
                lang: nil,
                format: nil,
                limit: nil
            ))
            let result = try await self.client.getStationsList(input)
            switch result {
            case .ok(let ok):
                if case let .json(model) = ok.body {
                    await self.cache.set(cacheKey, value: model, ttl: 6 * 3600)
                    return model
                } else {
                    throw APIError.invalidResponse
                }
            case .undocumented(let statusCode, _):
                throw self.mapStatusToError(statusCode)
            }
        }
    }

    func getCarrierInfo(code: String) async throws -> CarrierInfoResponse {
        logRequest("getCarrierInfo", parameters: ["code": code])
        return try await handleOperation(name: "getCarrierInfo") { [self] in
            let input = Ops.getCarrierInfo.Input(query: .init(
                apikey: self.apiKey,
                code: code,
                lang: nil,
                format: nil
            ))
            let result = try await self.client.getCarrierInfo(input)
            switch result {
            case .ok(let ok):
                if case let .json(model) = ok.body { return model }
                else { throw APIError.invalidResponse }
            case .undocumented(let statusCode, _):
                throw self.mapStatusToError(statusCode)
            }
        }
    }

    func getCopyrightInfo() async throws -> CopyrightResponse {
        logRequest("getCopyrightInfo", parameters: [:])
        return try await handleOperation(name: "getCopyrightInfo") { [self] in
            let input = Ops.getCopyrightInfo.Input(query: .init(
                apikey: self.apiKey,
                format: nil,
                lang: nil
            ))
            let result = try await self.client.getCopyrightInfo(input)
            switch result {
            case .ok(let ok):
                if case let .json(model) = ok.body { return model }
                else { throw APIError.invalidResponse }
            case .undocumented(let statusCode, _):
                throw self.mapStatusToError(statusCode)
            }
        }
    }
}

// MARK: - Simple Logger
struct Logger {
    func info(_ message: String) {
        print("[YandexRasp] \(message)")
    }
}
