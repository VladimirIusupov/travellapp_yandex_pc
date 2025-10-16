import Foundation
import SwiftUI

enum APITransportError: Error {
    case noInternet
    case server(String)
    case decoding(String)
    case unknown(Error)
}

final class SchedulesAPIClient: SchedulesAPI {
    @MainActor
    private var alerts: AppAlerts? {
        _alerts
    }
    private static var _sharedAlerts: AppAlerts?
    private var _alerts: AppAlerts? { SchedulesAPIClient._sharedAlerts }

    init(appAlerts: AppAlerts? = nil) {
        SchedulesAPIClient._sharedAlerts = appAlerts ?? SchedulesAPIClient._sharedAlerts
    }

    // MARK: - API

    func carriers(from: String, to: String, filter: CarriersFilter?) async throws -> [CarrierItem] {
        do {
            // TODO: вызов реального сгенерированного API из Client.swift.
            try await Task.sleep(nanoseconds: 300_000_000)
            return [
                .init(logoSystemName: "train.side.front.car", name: "РЖД", subtitle: "С пересадкой в Костроме", depTime: "22:30", arrTime: "08:15", duration: "20 часов")
            ]
        } catch {
            let mapped = map(error)
            await report(mapped)
            throw mapped
        }
    }

    private func map(_ error: Error) -> APITransportError {
        if let urlErr = error as? URLError {
            switch urlErr.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return .noInternet
            default:
                return .unknown(urlErr)
            }
        }
        if let api = error as? APITransportError { return api }
        return .unknown(error)
    }

    @MainActor
    private func report(_ error: APITransportError) {
        guard let alerts = alerts ?? SchedulesAPIClient._sharedAlerts else { return }
        switch error {
        case .noInternet:
            alerts.presentNoInternet()
        case .server(let message):
            alerts.presentServerError(message)
        case .decoding(let msg):
            alerts.presentServerError("Ошибка данных: \(msg)")
        case .unknown:
            alerts.presentServerError("Неизвестная ошибка. Повторите попытку.")
        }
    }
}
