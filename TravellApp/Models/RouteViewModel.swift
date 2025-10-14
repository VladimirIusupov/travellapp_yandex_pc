import Foundation

struct RoutePlace: Equatable {
    var cityTitle: String?
    var cityCode: String?
    var stationTitle: String?
    var stationCode: String?

    var displayTitle: String? {
        guard let city = cityTitle else { return nil }
        if let st = stationTitle { return "\(city), \(st)" }
        return city
    }
}

final class RouteViewModel: ObservableObject {
    @Published var from: RoutePlace = .init()
    @Published var to: RoutePlace   = .init()

    var canSearch: Bool { from.stationCode != nil && to.stationCode != nil }

    func swapPlaces() { (from, to) = (to, from) }

    // из выбора города
    func setFromCity(title: String, code: String) {
        from.cityTitle = title; from.cityCode = code
        from.stationTitle = nil; from.stationCode = nil
    }
    func setToCity(title: String, code: String) {
        to.cityTitle = title; to.cityCode = code
        to.stationTitle = nil; to.stationCode = nil
    }

    // из выбора станции
    func setFromStation(title: String, code: String) {
        from.stationTitle = title; from.stationCode = code
    }
    func setToStation(title: String, code: String) {
        to.stationTitle = title; to.stationCode = code
    }
}


extension RouteViewModel {
    /// Код для запросов (в приоритете станция, иначе город)
    var fromCodeForSearch: String? {
        from.stationCode ?? from.cityCode
    }
    var toCodeForSearch: String? {
        to.stationCode ?? to.cityCode
    }
}
