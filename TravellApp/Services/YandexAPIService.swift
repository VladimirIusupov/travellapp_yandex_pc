import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

// Алиасы для удобства
typealias ScheduleResponse = Components.Schemas.ScheduleResponse
typealias StationScheduleResponse = Components.Schemas.StationScheduleResponse
typealias ThreadStationsResponse = Components.Schemas.ThreadStationsResponse
typealias NearestStationsResponse = Components.Schemas.NearestStationsResponse
typealias NearestSettlementResponse = Components.Schemas.NearestSettlementResponse
typealias StationsListResponse = Components.Schemas.StationsListResponse
typealias CarrierInfoResponse = Components.Schemas.CarrierInfoResponse
typealias CopyrightResponse = Components.Schemas.CopyrightResponse

// Кастомная ошибка
enum APIError: Error {
    case invalidResponse
}

// Протокол универсального сервиса
protocol YandexRaspServiceProtocol {
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStationsResponse
    func getSchedule(from: String, to: String) async throws -> ScheduleResponse
    func getStationSchedule(station: String) async throws -> StationScheduleResponse
    func getThread(uid: String) async throws -> ThreadStationsResponse
    func getNearestSettlement(lat: Double, lng: Double, distance: Int) async throws -> NearestSettlementResponse
    func getStationsList() async throws -> StationsListResponse
    func getCarrier(code: String) async throws -> CarrierInfoResponse
    func getCopyright() async throws -> CopyrightResponse
}


final class YandexRaspService: YandexRaspServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    private func logRequest(_ name: String, parameters: [String: Any] = [:]) {
        print("🚀 API Request: \(name)")
        print("   API Key: \(apikey.prefix(8))...")
        print("   Parameters: \(parameters)")
    }
    
    private func logResponse(_ name: String, success: Bool, details: String = "") {
        let status = success ? "✅" : "❌"
        print("\(status) API Response: \(name)")
        if !details.isEmpty {
            print("   Details: \(details)")
        }
    }
    
    // Вспомогательная функция для чтения тела ответа
    private func readResponseBody(_ body: HTTPBody?) async -> String {
        guard let body = body else { return "No body" }
        
        do {
            let data = try await Data(collecting: body, upTo: 1024 * 1024) // Читаем до 1MB
            return String(data: data, encoding: .utf8) ?? "Cannot decode body as UTF-8"
        } catch {
            return "Error reading body: \(error.localizedDescription)"
        }
    }
    
    // Ближайшие станции
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStationsResponse {
        logRequest("getNearestStations", parameters: ["lat": lat, "lng": lng, "distance": distance])
        
        do {
            let response = try await client.getNearestStations(query: .init(
                apikey: apikey,
                lat: lat,
                lng: lng,
                distance: distance
            ))
            
            switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                case .json(let stations):
                    logResponse("getNearestStations", success: true, details: "Found \(stations.stations?.count ?? 0) stations")
                    return stations
                @unknown default:
                    logResponse("getNearestStations", success: false, details: "Unexpected response format")
                    throw APIError.invalidResponse
                }
            case .undocumented(let statusCode, let payload):
                let bodyText = await readResponseBody(payload.body)
                logResponse("getNearestStations", success: false, details: "Status: \(statusCode), Body: \(bodyText.prefix(500))")
                throw APIError.invalidResponse
            }
        } catch {
            logResponse("getNearestStations", success: false, details: "Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Расписание между станциями
    func getSchedule(from: String, to: String) async throws -> ScheduleResponse {
        logRequest("getSchedule", parameters: ["from": from, "to": to])
        
        do {
            let response = try await client.getSchedule(query: .init(
                apikey: apikey,
                from: from,
                to: to
            ))
            
            switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                case .json(let schedule):
                    logResponse("getSchedule", success: true, details: "Found \(schedule.segments?.count ?? 0) segments")
                    return schedule
                @unknown default:
                    logResponse("getSchedule", success: false, details: "Unexpected response format")
                    throw APIError.invalidResponse
                }
            case .undocumented(let statusCode, let payload):
                let bodyText = await readResponseBody(payload.body)
                logResponse("getSchedule", success: false, details: "Status: \(statusCode), Body: \(bodyText.prefix(500))")
                throw APIError.invalidResponse
            }
        } catch {
            logResponse("getSchedule", success: false, details: "Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Расписание на станции
    func getStationSchedule(station: String) async throws -> StationScheduleResponse {
        logRequest("getStationSchedule", parameters: ["station": station])
        
        do {
            let response = try await client.getStationSchedule(query: .init(
                apikey: apikey,
                station: station
            ))
            
            switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                case .json(let schedule):
                    logResponse("getStationSchedule", success: true, details: "Schedule retrieved")
                    return schedule
                @unknown default:
                    logResponse("getStationSchedule", success: false, details: "Unexpected response format")
                    throw APIError.invalidResponse
                }
            case .undocumented(let statusCode, let payload):
                let bodyText = await readResponseBody(payload.body)
                logResponse("getStationSchedule", success: false, details: "Status: \(statusCode), Body: \(bodyText.prefix(500))")
                throw APIError.invalidResponse
            }
        } catch {
            logResponse("getStationSchedule", success: false, details: "Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Станции маршрута
    func getThread(uid: String) async throws -> ThreadStationsResponse {
        logRequest("getThread", parameters: ["uid": uid])
        
        do {
            let response = try await client.getThreadStations(query: .init(
                apikey: apikey,
                uid: uid
            ))
            
            switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                case .json(let thread):
                    logResponse("getThread", success: true, details: "Thread stations retrieved")
                    return thread
                @unknown default:
                    logResponse("getThread", success: false, details: "Unexpected response format")
                    throw APIError.invalidResponse
                }
            case .undocumented(let statusCode, let payload):
                let bodyText = await readResponseBody(payload.body)
                logResponse("getThread", success: false, details: "Status: \(statusCode), Body: \(bodyText.prefix(500))")
                throw APIError.invalidResponse
            }
        } catch {
            logResponse("getThread", success: false, details: "Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Ближайший населенный пункт
    func getNearestSettlement(lat: Double, lng: Double, distance: Int) async throws -> NearestSettlementResponse {
        logRequest("getNearestSettlement", parameters: ["lat": lat, "lng": lng, "distance": distance])
        
        do {
            let response = try await client.getNearestSettlement(query: .init(
                apikey: apikey,
                lat: lat,
                lng: lng,
                distance: distance
            ))
            
            switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                case .json(let settlement):
                    logResponse("getNearestSettlement", success: true, details: "Settlement found")
                    return settlement
                @unknown default:
                    logResponse("getNearestSettlement", success: false, details: "Unexpected response format")
                    throw APIError.invalidResponse
                }
            case .undocumented(let statusCode, let payload):
                let bodyText = await readResponseBody(payload.body)
                logResponse("getNearestSettlement", success: false, details: "Status: \(statusCode), Body: \(bodyText.prefix(500))")
                throw APIError.invalidResponse
            }
        } catch {
            logResponse("getNearestSettlement", success: false, details: "Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Список станций
    func getStationsList() async throws -> StationsListResponse {
        logRequest("getStationsList", parameters: [:])
        
        do {
            let response = try await client.getStationsList(query: .init(
                apikey: apikey
            ))
            
            switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                case .json(let stations):
                    logResponse("getStationsList", success: true, details: "Stations list retrieved")
                    return stations
                @unknown default:
                    logResponse("getStationsList", success: false, details: "Unexpected response format")
                    throw APIError.invalidResponse
                }
            case .undocumented(let statusCode, let payload):
                let bodyText = await readResponseBody(payload.body)
                logResponse("getStationsList", success: false, details: "Status: \(statusCode), Body: \(bodyText.prefix(500))")
                throw APIError.invalidResponse
            }
        } catch {
            logResponse("getStationsList", success: false, details: "Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Информация о перевозчике
    func getCarrier(code: String) async throws -> CarrierInfoResponse {
        logRequest("getCarrier", parameters: ["code": code])
        
        do {
            let response = try await client.getCarrierInfo(query: .init(
                apikey: apikey,
                code: code
            ))
            
            switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                case .json(let carrier):
                    logResponse("getCarrier", success: true, details: "Carrier info retrieved")
                    return carrier
                @unknown default:
                    logResponse("getCarrier", success: false, details: "Unexpected response format")
                    throw APIError.invalidResponse
                }
            case .undocumented(let statusCode, let payload):
                let bodyText = await readResponseBody(payload.body)
                logResponse("getCarrier", success: false, details: "Status: \(statusCode), Body: \(bodyText.prefix(500))")
                throw APIError.invalidResponse
            }
        } catch {
            logResponse("getCarrier", success: false, details: "Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Информация о правах
    func getCopyright() async throws -> CopyrightResponse {
        logRequest("getCopyright", parameters: [:])
        
        do {
            let response = try await client.getCopyrightInfo(query: .init(
                apikey: apikey
            ))
            
            switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                case .json(let copyright):
                    logResponse("getCopyright", success: true, details: "Copyright info retrieved")
                    return copyright
                @unknown default:
                    logResponse("getCopyright", success: false, details: "Unexpected response format")
                    throw APIError.invalidResponse
                }
            case .undocumented(let statusCode, let payload):
                let bodyText = await readResponseBody(payload.body)
                logResponse("getCopyright", success: false, details: "Status: \(statusCode), Body: \(bodyText.prefix(500))")
                throw APIError.invalidResponse
            }
        } catch {
            logResponse("getCopyright", success: false, details: "Error: \(error.localizedDescription)")
            throw error
        }
    }
}
