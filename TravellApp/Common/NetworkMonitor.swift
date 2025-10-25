import Network
import SwiftUI
import Combine

final class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    @Published var isReachable: Bool = true

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let reachable = (path.status == .satisfied)
                if self?.isReachable != reachable {
                    self?.isReachable = reachable
                    if let alerts = Self.locateAppAlerts() {
                        if !reachable { alerts.presentNoInternet() }
                    }
                }
            }
        }
        monitor.start(queue: queue)
    }

    deinit { monitor.cancel() }
    private static func locateAppAlerts() -> AppAlerts? {
        nil
    }
}
