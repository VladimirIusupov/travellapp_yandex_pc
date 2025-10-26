import Foundation
import SwiftUI

// MARK: - ViewModel
@MainActor
final class StationPickerViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var stations: [Station] = []
    @Published var isLoading: Bool = false
    @Published var appError: AppError?
    @Published var searchText: String = ""
    
    // MARK: - Computed Properties
    var filteredStations: [Station] {
        filterStations(searchText: searchText)
    }
    
    // MARK: - Private Properties
    private let cityId: String
    
    // MARK: - Init
    init(cityId: String) {
        self.cityId = cityId
    }
    
    // MARK: - Public Methods
    func loadStations() async {
        isLoading = true
        appError = nil
        defer { isLoading = false }
        
        do {
            let data = try await NetworkClient.shared.fetchAllStations()
            
            let settlements = data.countries?
                .flatMap { $0.regions ?? [] }
                .flatMap { $0.settlements ?? [] } ?? []
            
            guard let selectedCity = settlements.first(where: { $0.codes?.yandex_code == cityId }) else {
                self.stations = []
                return
            }
            
            let stationsInCity = selectedCity.stations?.compactMap { station -> Station? in
                guard let code = station.codes?.yandex_code,
                      let title = station.title else { return nil }
                return Station(id: code, title: title)
            } ?? []
            
            self.stations = stationsInCity.sorted { $0.title < $1.title }
            
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                appError = .noInternet
            case .badServerResponse, .cannotConnectToHost:
                appError = .serverError
            default:
                appError = .unknown
            }
        } catch {
            appError = .serverError
        }
    }
    
    // MARK: - Business Logic (Filter)
    func filterStations(searchText: String) -> [Station] {
        guard !searchText.isEmpty else { return stations }
        return stations.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
}
