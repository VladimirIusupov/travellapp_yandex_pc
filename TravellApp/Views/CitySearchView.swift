import SwiftUI

struct CitySearchView: View {
    let title: String
    var onPick: (String, String) -> Void   // (title, code)

    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    // MARK: Поиск по API в следующем спринте
    // Временно статический список, позже подключим реальный АПИ
    @State private var allCities = ["Москва", "Санкт-Петербург", "Казань", "Екатеринбург", "Новосибирск", "Нижний Новгород"]
    
    var filtered: [String] {
        guard !query.isEmpty else { return allCities }
        let q = query.folding(options: .diacriticInsensitive, locale: .current).lowercased()
        return allCities.filter { $0.folding(options: .diacriticInsensitive, locale: .current).lowercased().contains(q) }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filtered, id: \.self) { city in
                    Button {
                        onPick(city, UUID().uuidString)
                        dismiss()
                    } label: {
                        Text(city)
                    }
                }
            }
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Поиск города")
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") { dismiss() }
                }
            }
        }
    }
}
