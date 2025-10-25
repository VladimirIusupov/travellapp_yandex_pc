import Foundation

struct StationRow: Identifiable, Hashable {
    let id: String
    let title: String
}

final class StationPickerViewModel: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var filtered: [StationRow] = []

    private let all: [StationRow]

    init(stations: [StationRow]) {
        self.all = stations
        self.filtered = stations
    }

    func updateFilter() {
        let q = query.normalizedForSearch()
        filtered = q.isEmpty ? all : all.filter {
            let t = $0.title.normalizedForSearch()
            return t.contains(q) || t.hasPrefix(q)
        }
    }
}

fileprivate extension String {
    func normalizedForSearch() -> String {
        self.folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
            .replacingOccurrences(of: "ё", with: "е")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
