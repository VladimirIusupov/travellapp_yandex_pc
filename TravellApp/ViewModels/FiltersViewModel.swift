import Foundation
import SwiftUI

// MARK: - ViewModel
@MainActor
final class FiltersViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var morning = false
    @Published var day = false
    @Published var evening = false
    @Published var night = false
    @Published var transfers: Bool?
    
    // MARK: - Computed Properties
    var isApplyEnabled: Bool {
        (morning || day || evening || night) && transfers != nil
    }
    
    // MARK: - Public Methods
    func buildFilters() -> Filters? {
        guard let transfers else { return nil }
        return Filters(
            morning: morning,
            day: day,
            evening: evening,
            night: night,
            transfers: transfers
        )
    }
    
    func selectTransfer(_ value: Bool) {
        transfers = value
    }
}
