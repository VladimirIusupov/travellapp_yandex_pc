import Foundation
import SwiftUI

// MARK: - Модели списка перевозчиков

public struct CarrierItem: Identifiable, Hashable {
    public let id = UUID()
    public let logoSystemName: String
    public let name: String
    public let subtitle: String?
    public let depTime: String       // "HH:mm"
    public let arrTime: String       // "HH:mm"
    public let duration: String      // "9 часов" и т.п.

    public init(logoSystemName: String,
                name: String,
                subtitle: String? = nil,
                depTime: String,
                arrTime: String,
                duration: String) {
        self.logoSystemName = logoSystemName
        self.name = name
        self.subtitle = subtitle
        self.depTime = depTime
        self.arrTime = arrTime
        self.duration = duration
    }
}

public struct CarriersFilter: Equatable {
    public var morning: Bool = false   // 06–12
    public var day: Bool = false       // 12–18
    public var evening: Bool = false   // 18–24
    public var night: Bool = false     // 00–06
    public var withTransfers: Bool? = nil

    public init(morning: Bool = false,
                day: Bool = false,
                evening: Bool = false,
                night: Bool = false,
                withTransfers: Bool? = nil) {
        self.morning = morning
        self.day = day
        self.evening = evening
        self.night = night
        self.withTransfers = withTransfers
    }
}

// ВАЖНО: НЕ объявляй здесь протокол SchedulesAPI — он уже есть в Environment+API.swift
// public protocol SchedulesAPI { ... }

// MARK: - ViewModel списка перевозчиков

final class CarriersListViewModel: ObservableObject {
    // Исходные данные и отфильтрованный результат
    @Published var all: [CarrierItem] = []
    @Published var filtered: [CarrierItem] = []

    // Текущие фильтры
    @Published var filter: CarriersFilter = .init()

    // Заголовок экрана (из RouteView)
    @Published var titleFrom: String
    @Published var titleTo: String
    
    // Коды станций для запуска загрузки из списка
    @Published var fromCode: String = ""
    @Published var toCode: String = ""

    // Флаг чтобы не запрашивать повторно при каждом .onAppear/.task
    @Published private(set) var didLoadOnce: Bool = false

    // Зависимость от API (экзистенциал протокола)
    private let api: any SchedulesAPI

    // Временное использование моков (выключить при подключении API)
    private let useMocks: Bool

    init(titleFrom: String,
         titleTo: String,
         api: any SchedulesAPI = SchedulesAPIClient(),
         useMocks: Bool = true) {
        self.titleFrom = titleFrom
        self.titleTo = titleTo
        self.api = api
        self.useMocks = useMocks
    }

    // MARK: - Загрузка данных

    @MainActor
    func reload(fromCode: String, toCode: String) async {
        if useMocks {
            self.all = Self.mockCarriers
            applyFilter()
            return
        }

        do {
            let items = try await api.carriers(from: fromCode, to: toCode, filter: filter)
            self.all = items
            applyFilter()
        } catch {
            // Ошибка уже отображена через AppAlerts внутри клиента.
        }
    }
    
    func configureRoute(fromCode: String, toCode: String) {
        self.fromCode = fromCode
        self.toCode   = toCode
        self.didLoadOnce = false
    }

    @MainActor
    func ensureLoaded() async {
        guard !didLoadOnce else { return }
        await reload(fromCode: fromCode, toCode: toCode)
        didLoadOnce = true
    }

    // MARK: - Применение фильтра

    func updateFilter(_ new: CarriersFilter) {
        filter = new
        applyFilter()
    }

    private func applyFilter() {
        var items = all

        // Разбор часа отправления
        func depHour(_ item: CarrierItem) -> Int {
            Int(item.depTime.split(separator: ":").first ?? "0") ?? 0
        }

        // Фильтр по времени суток
        let timeChecked = filter.morning || filter.day || filter.evening || filter.night
        if timeChecked {
            items = items.filter { it in
                let h = depHour(it)
                let isMorning = (6...11).contains(h)
                let isDay     = (12...17).contains(h)
                let isEvening = (18...23).contains(h)
                let isNight   = (0...5).contains(h)
                return (filter.morning && isMorning)
                    || (filter.day && isDay)
                    || (filter.evening && isEvening)
                    || (filter.night && isNight)
            }
        }

        // Фильтр по пересадкам (эвристика — наличие subtitle)
        if let transfers = filter.withTransfers {
            items = items.filter { it in
                let hasTransfer = (it.subtitle?.isEmpty == false)
                return transfers ? hasTransfer : !hasTransfer
            }
        }

        filtered = items
    }
}

// MARK: - Моки для демо

extension CarriersListViewModel {
    static let mockCarriers: [CarrierItem] = [
        .init(logoSystemName: "rzd",
              name: "РЖД",
              subtitle: "С пересадкой в Костроме",
              depTime: "22:30",
              arrTime: "08:15",
              duration: "20 часов"),
        .init(logoSystemName: "fgk",
              name: "ФГК",
              subtitle: nil,
              depTime: "01:15",
              arrTime: "09:00",
              duration: "9 часов"),
        .init(logoSystemName: "ural_oil",
              name: "Урал логистика",
              subtitle: nil,
              depTime: "12:30",
              arrTime: "21:00",
              duration: "9 часов"),
        .init(logoSystemName: "shippingbox.fill",
              name: "BoxTrans",
              subtitle: "С пересадкой в Твери",
              depTime: "10:15",
              arrTime: "19:40",
              duration: "9 часов"),
        .init(logoSystemName: "tram.fill",
              name: "ГТК",
              subtitle: nil,
              depTime: "11:05",
              arrTime: "20:25",
              duration: "9 часов")
    ]
}

