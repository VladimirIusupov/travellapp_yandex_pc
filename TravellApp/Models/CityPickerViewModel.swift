import Foundation

struct CityRow: Identifiable, Hashable {
    let id: String
    let title: String
}

final class CityPickerViewModel: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var rows: [CityRow] = []
    @Published private(set) var filtered: [CityRow] = []

    init(cities: [CityRow]) {
        self.rows = cities
        self.filtered = cities
    }

    func updateFilter() {
        let q = query.normalizedForSearch()
        filtered = q.isEmpty ? rows : rows.filter {
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
