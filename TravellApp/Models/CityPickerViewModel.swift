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
        let q = normalized(query)
        filtered = q.isEmpty
        ? rows
        : rows.filter { normalized($0.title).contains(q) || normalized($0.title).hasPrefix(q) }
    }

    private func normalized(_ s: String) -> String {
        s.folding(options: .diacriticInsensitive, locale: .current)
         .lowercased()
         .replacingOccurrences(of: "ё", with: "е")
         .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
