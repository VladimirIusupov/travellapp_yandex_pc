import Foundation
import SwiftUI

// MARK: - ViewModel
@MainActor
final class SearchResultsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var originalResults: [Components.Schemas.Segment] = []
    @Published var displayedResults: [Components.Schemas.Segment] = []
    @Published var isLoading: Bool = false
    @Published var appError: AppError?
    @Published var filters: Filters?
    @Published var filtersApplied: Bool = false
    
    // MARK: - Public Methods
    func loadResults(from: String, to: String) async {
        isLoading = true
        appError = nil
        defer { isLoading = false }
        
        do {
            let data = try await NetworkClient.shared.fetchSchedule(from: from, to: to)
            self.originalResults = data.segments ?? []
            self.displayedResults = self.originalResults
            print(" Загружено сегментов: \(self.originalResults.count)")
            
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                appError = .noInternet
            case .badServerResponse, .cannotConnectToHost:
                appError = .serverError
                print(urlError)
            default:
                appError = .unknown
            }
        } catch {
            appError = .unknown
        }
    }
    
    func applyFilters(_ newFilters: Filters?) {
        filters = newFilters
        filtersApplied = newFilters != nil
        
        guard let filters else {
            displayedResults = originalResults
            return
        }
        
        Task {
            displayedResults = await filterSegments(filters: filters)
        }
    }
    
    // MARK: - Filtering Logic
    private func filterSegments(filters: Filters) async -> [Components.Schemas.Segment] {
        await withTaskGroup(of: Components.Schemas.Segment?.self) { group in
            for seg in originalResults {
                group.addTask {
                    guard let dep = seg.departure else { return nil }
                    
                    // Проверка на пересадки
                    if let hasTransfers = seg.has_transfers {
                        if hasTransfers != filters.transfers { return nil }
                    } else {
                        if filters.transfers != false { return nil }
                    }
                    
                    // Проверка по времени
                    let hour = Calendar.current.component(.hour, from: dep)
                    var timeMatches = false
                    if filters.morning { timeMatches = timeMatches || (hour >= 6 && hour < 12) }
                    if filters.day     { timeMatches = timeMatches || (hour >= 12 && hour < 18) }
                    if filters.evening { timeMatches = timeMatches || (hour >= 18 && hour < 24) }
                    if filters.night   { timeMatches = timeMatches || (hour >= 0 && hour < 6) }
                    
                    return timeMatches ? seg : nil
                }
            }
            
            var result: [Components.Schemas.Segment] = []
            for await segment in group {
                if let seg = segment { result.append(seg) }
            }
            return result
        }
    }
}
