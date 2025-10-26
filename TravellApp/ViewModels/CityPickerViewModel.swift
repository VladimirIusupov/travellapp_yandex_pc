import SwiftUI

// MARK: - ViewModel
@MainActor
final class CityPickerViewModel: ObservableObject {
    
    @Published var cities: [City] = []
    @Published var isLoading = false
    @Published var appError: AppError?
    @Published var searchText: String = ""
    
    var filteredCities: [City] {
        guard !searchText.isEmpty else { return cities }
        return cities.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    func loadCities() async {
        isLoading = true
        appError = nil
        defer { isLoading = false }
        
        do {
            let data = try await NetworkClient.shared.fetchAllStations()
            
            let settlements = data.countries?
                .flatMap { $0.regions ?? [] }
                .flatMap { $0.settlements ?? [] } ?? []
            
            let citiesWithDuplicates = settlements.compactMap { settlement -> City? in
                guard let title = settlement.title,
                      let code = settlement.codes?.yandex_code else { return nil }
                return City(id: code, title: title)
            }
            
            var seen = Set<String>()
            let uniqueCities = citiesWithDuplicates.filter { city in
                if seen.contains(city.id) { return false }
                seen.insert(city.id)
                return true
            }
            
            self.cities = uniqueCities.sorted { $0.title < $1.title }
            
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
            appError = .unknown
        }
    }
}
