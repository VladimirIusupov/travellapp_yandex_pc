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
        let q = normalized(query)
        filtered = q.isEmpty
        ? all
        : all.filter { normalized($0.title).contains(q) || normalized($0.title).hasPrefix(q) }
    }

    private func normalized(_ s: String) -> String {
        s.folding(options: .diacriticInsensitive, locale: .current)
         .lowercased()
         .replacingOccurrences(of: "ё", with: "е")
         .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
