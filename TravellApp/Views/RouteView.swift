import SwiftUI

struct RouteView: View {
    // MARK: - VM
    @ObservedObject var viewModel: RouteViewModel
    init(viewModel: RouteViewModel = RouteViewModel()) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }

    // MARK: - Навигация
    private enum Dest: Hashable {
        case carriers
        case filters
        case carrierDetails(CarrierItem)
    }
    @State private var path: [Dest] = []

    // MARK: - Полноэкранные флоу
    @State private var showFromFlow = false
    @State private var showToFlow   = false

    // MARK: - Перевозчики
    @StateObject private var carriersVM = CarriersListViewModel(titleFrom: "", titleTo: "")

    // MARK: - Stories
    @State private var showStories = false
    @State private var storyIndex  = 0
    private let stories = Story.mock
    @StateObject private var storyStore = StoryStore()

    // MARK: - Тело
    var body: some View {
        NavigationStack(path: $path) {
            RouteContent(
                fromTitle: fromTitle,
                toTitle:   toTitle,
                canSearch: viewModel.canSearch,
                onTapFrom: { showFromFlow = true },
                onTapTo:   { showToFlow   = true },
                onSearch:  performSearch,
                stories: stories,
                onOpenStory: openStory,
                storyStore: storyStore
            )
            .navigationDestination(for: Dest.self, destination: destination)
            .fullScreenCover(isPresented: $showStories, content: storyPlayer)
            .background(.ypWhite)
        }
        .fullScreenCityFlow(isPresented: $showFromFlow, mode: .from, finish: setFrom)
        .fullScreenCityFlow(isPresented: $showToFlow,   mode: .to,   finish: setTo)
        .onReceive(NotificationCenter.default.publisher(for: .init("swapRoutePlaces"))) { _ in
            viewModel.swapPlaces()
        }
    }
}

// MARK: - Приватные помощники
private extension RouteView {
    var fromTitle: String { viewModel.from.displayTitle ?? "Откуда" }
    var toTitle:   String { viewModel.to.displayTitle   ?? "Куда"   }

    func performSearch() {
        carriersVM.titleFrom = fromTitle
        carriersVM.titleTo   = toTitle
        let from = viewModel.fromCodeForSearch ?? ""
        let to   = viewModel.toCodeForSearch   ?? ""
        carriersVM.configureRoute(fromCode: from, toCode: to)
        path.append(.carriers)
    }

    func openStory(_ index: Int) {
        storyIndex  = index
        showStories = true
        storyStore.markSeen(stories[index].id)
    }

    @ViewBuilder
    private func destination(_ dest: Dest) -> some View {
        switch dest {
        case .carriers:
            CarriersListView(
                viewModel: carriersVM,
                onOpenFilters: { path.append(.filters) },
                onOpenDetails: { item in path.append(.carrierDetails(item)) }
            )

        case .filters:
            FiltersView(
                initial: carriersVM.filter,
                onApply: { new in
                    carriersVM.updateFilter(new)
                    path.removeLast()
                }
            )

        case let .carrierDetails(item):
            CarrierDetailsView(item: item)
        }
    }

    @ViewBuilder
    func storyPlayer() -> some View {
        StoryPlayerView(
            stories: stories,
            startIndex: storyIndex,
            onSeen: { i in storyStore.markSeen(stories[i].id) },
            onClose: { showStories = false }
        )
    }

    func setFrom(city: CityRow, station: StationRow) {
        viewModel.setFromCity(title: city.title, code: city.id)
        viewModel.setFromStation(title: station.title, code: station.id)
    }

    func setTo(city: CityRow, station: StationRow) {
        viewModel.setToCity(title: city.title, code: city.id)
        viewModel.setToStation(title: station.title, code: station.id)
    }
}

// MARK: - Моки городов/станций
private extension RouteView {
    var mockCities: [CityRow] {
        [
            .init(id: "msk",  title: "Москва"),
            .init(id: "spb",  title: "Санкт Петербург"),
            .init(id: "sochi",title: "Сочи"),
            .init(id: "kras", title: "Краснодар"),
            .init(id: "kzn",  title: "Казань"),
            .init(id: "omsk", title: "Омск")
        ]
    }

    func mockStations(for city: CityRow) -> [StationRow] {
        switch city.id {
        case "msk":
            return [
                .init(id: "kiev", title: "Киевский вокзал"),
                .init(id: "kursk", title: "Курский вокзал"),
                .init(id: "yar",  title: "Ярославский вокзал"),
                .init(id: "bel",  title: "Белорусский вокзал"),
                .init(id: "sav",  title: "Савёловский вокзал"),
                .init(id: "len",  title: "Ленинградский вокзал")
            ]
        case "spb":
            return [
                .init(id: "mos", title: "Московский вокзал"),
                .init(id: "lad", title: "Ладожский вокзал"),
                .init(id: "bal", title: "Балтийский вокзал")
            ]
        default:
            return [.init(id: "ctr", title: "Центральный вокзал")]
        }
    }
}

// MARK: - Модификатор для флоу выбора города/станции

private extension View {
    func fullScreenCityFlow(
        isPresented: Binding<Bool>,
        mode: CityStationFlowView.Mode,
        finish: @escaping (_ city: CityRow, _ station: StationRow) -> Void
    ) -> some View {
        fullScreenCover(isPresented: isPresented) {
            CityStationFlowView(
                mode: mode,
                initialCities: RouteView().mockCities,
                stationsProvider: RouteView().mockStations(for:),
                onFinish: finish
            )
        }
    }
}
