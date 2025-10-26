import SwiftUI

@MainActor
final class MainViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var fromTitle: String = ""
    @Published var toTitle: String = ""
    
    @Published var fromStation: SelectedStation?
    @Published var toStation: SelectedStation?
    
    @Published var pickFrom: Bool = true
    @Published var appError: AppError?
    
    @Published var path = NavigationPath()
    
    // MARK: - Computed
    var canSearch: Bool {
        fromStation != nil && toStation != nil
    }
    
    // MARK: - Public Methods
    
    func simulateErrorCheck() {
        let connected = Reachability.isConnectedToNetwork()
        if !connected {
            appError = .noInternet
        }
    }
    
    func swapStations() {
        swap(&fromTitle, &toTitle)
        swap(&fromStation, &toStation)
    }
    
    func goToCityPicker(isFrom: Bool) {
        pickFrom = isFrom
        path.append(Route.cityPicker(isFrom: isFrom))
    }
    
    func goToStationPicker(cityId: String, cityTitle: String, isFrom: Bool) {
        path.removeLast()
        path.append(Route.stationPicker(cityId: cityId, cityTitle: cityTitle, isFrom: isFrom))
    }
    
    func selectStation(_ station: SelectedStation, cityTitle: String, isFrom: Bool) {
        if isFrom {
            fromStation = station
            fromTitle = "\(cityTitle), \(station.title)"
        } else {
            toStation = station
            toTitle = "\(cityTitle), \(station.title)"
        }
        path.removeLast()
    }
}
