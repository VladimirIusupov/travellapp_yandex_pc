import Foundation

struct CarrierItem: Identifiable, Hashable {
    let id = UUID()
    let logoSystemName: String   // временно системная иконка вместо лого
    let name: String             // "РЖД"
    let subtitle: String?        // "С пересадкой в Костроме"
    let depTime: String          // "22:30"
    let arrTime: String          // "08:15"
    let duration: String         // "20 часов"
}

struct CarriersFilter: Equatable {
    var morning: Bool = false    // 06–12
    var day: Bool = false        // 12–18
    var evening: Bool = false    // 18–00
    var night: Bool = false      // 00–06
    var withTransfers: Bool? = nil // nil=без разницы, true/false — да/нет
}

final class CarriersListViewModel: ObservableObject {
    @Published var all: [CarrierItem] = []
    @Published var filtered: [CarrierItem] = []
    @Published var filter: CarriersFilter = .init()

    // В заголовке показываем «Москва (Ярославский) → Санкт-Петербург (Балтийский)»
    @Published var titleFrom: String = ""
    @Published var titleTo: String = ""

    init(titleFrom: String, titleTo: String) {
        self.titleFrom = titleFrom
        self.titleTo = titleTo
        loadMock()
        applyFilter()
    }

    func updateFilter(_ new: CarriersFilter) {
        filter = new
        applyFilter()
    }

    private func applyFilter() {
        // мок-фильтрация по времени: для примера «утро» оставим элементы, где depTime < 12:00 и т.д.
        func depHour(_ item: CarrierItem) -> Int {
            let comps = item.depTime.split(separator: ":")
            return Int(comps.first ?? "0") ?? 0
        }

        var items = all

        let timeChecked = filter.morning || filter.day || filter.evening || filter.night
        if timeChecked {
            items = items.filter { item in
                let h = depHour(item)
                let morning = (6...11).contains(h)
                let day     = (12...17).contains(h)
                let evening = (18...23).contains(h)
                let night   = (0...5).contains(h)

                return (filter.morning && morning)
                    || (filter.day && day)
                    || (filter.evening && evening)
                    || (filter.night && night)
            }
        }

        // Пересадки — для мока «subtitle != nil» считается «с пересадкой»
        if let withTransfers = filter.withTransfers {
            items = items.filter { item in
                let hasTransfer = (item.subtitle?.isEmpty == false)
                return withTransfers ? hasTransfer : !hasTransfer
            }
        }

        filtered = items
    }

    private func loadMock() {
        all = [
            .init(logoSystemName: "train.side.front.car", name: "РЖД", subtitle: "С пересадкой в Костроме", depTime: "22:30", arrTime: "08:15", duration: "20 часов"),
            .init(logoSystemName: "flame", name: "ФГК", subtitle: nil, depTime: "01:15", arrTime: "09:00", duration: "8 часов"),
            .init(logoSystemName: "shippingbox", name: "Урал логистика", subtitle: nil, depTime: "12:30", arrTime: "21:45", duration: "9 часов"),
            .init(logoSystemName: "train.side.front.car", name: "РЖД", subtitle: nil, depTime: "22:30", arrTime: "08:15", duration: "20 часов")
        ]
    }
}
