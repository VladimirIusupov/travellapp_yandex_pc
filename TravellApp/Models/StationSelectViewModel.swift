import Foundation

struct StationItem: Identifiable, Equatable {
    let id: String       // station code
    let title: String    // station title
}

final class StationSelectViewModel: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var filtered: [StationItem] = []

    let cityTitle: String
    private let all: [StationItem]

    init(cityTitle: String, stations: [StationItem]) {
        self.cityTitle = cityTitle
        self.all = stations
        self.filtered = stations
    }

    func onQueryChange() {
        let q = query.folding(options: .diacriticInsensitive, locale: .current)
                      .lowercased()
                      .replacingOccurrences(of: "ё", with: "е")
                      .trimmingCharacters(in: .whitespacesAndNewlines)
        filtered = q.isEmpty
        ? all
        : all.filter { $0.title.folding(options: .diacriticInsensitive, locale: .current)
                .lowercased()
                .replacingOccurrences(of: "ё", with: "е")
                .contains(q)
        }
    }
}
