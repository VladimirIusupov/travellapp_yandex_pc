import SwiftUI

struct CitySearchView: View {
    let title: String
    var onPick: (String, String) -> Void   // (title, code)

    @Environment(\.dismiss) private var dismiss
    @State private var query = ""

    // временный список до подключения API
    @State private var allCities = [
        "Москва", "Санкт-Петербург", "Казань",
        "Екатеринбург", "Новосибирск", "Нижний Новгород"
    ]

    private var filtered: [String] {
        guard !query.isEmpty else { return allCities }
        let q = query.normalizedForSearch()
        return allCities.filter { $0.normalizedForSearch().contains(q) }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filtered, id: \.self) { city in
                    Button {
                        onPick(city, UUID().uuidString)
                        dismiss()
                    } label: { Text(city) }
                }
            }
            .searchable(text: $query,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Поиск города")
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") { dismiss() }
                }
            }
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
