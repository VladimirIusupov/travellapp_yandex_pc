import SwiftUI

protocol SchedulesAPI {
    func carriers(from: String, to: String, filter: CarriersFilter?) async throws -> [CarrierItem]
}

private struct SchedulesAPIKey: EnvironmentKey {
    static let defaultValue: SchedulesAPI = SchedulesAPIClient()
}

extension EnvironmentValues {
    var schedulesAPI: SchedulesAPI {
        get { self[SchedulesAPIKey.self] }
        set { self[SchedulesAPIKey.self] = newValue }
    }
}
