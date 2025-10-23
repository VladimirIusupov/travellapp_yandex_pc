import SwiftUI

struct RouteView: View {
    // VM экрана маршрута
    @ObservedObject var viewModel: RouteViewModel
    init(viewModel: RouteViewModel = RouteViewModel()) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

    // Навигация внутри главной вкладки (карточки перевозчиков/фильтры/детали)
    @State private var path: [RouteNav] = []
    enum RouteNav: Hashable {
        case carriers
        case filters
        case carrierDetails(CarrierItem)
    }

    // Полноэкранные флоу выбора города→станции (перекрывают TabBar)
    @State private var showFromFlow = false
    @State private var showToFlow   = false

    // VM списка перевозчиков храним в родителе, чтобы не терять состояние при пушах
    @StateObject private var carriersVM = CarriersListViewModel(titleFrom: "", titleTo: "")
    
    // Stories
    @State private var showStories = false
    @State private var storyIndex = 0
    private let stories = Story.mock
    @StateObject private var storyStore = StoryStore()

    
    //:TODO МОК-ДАННЫЕ
    private var mockCities: [CityRow] {
        [
            .init(id: "msk",  title: "Москва"),
            .init(id: "spb",  title: "Санкт Петербург"),
            .init(id: "sochi",title: "Сочи"),
            .init(id: "kras", title: "Краснодар"),
            .init(id: "kzn",  title: "Казань"),
            .init(id: "omsk", title: "Омск")
        ]
    }

    private func mockStations(for city: CityRow) -> [StationRow] {
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
    // --------------------------------------------

    var body: some View {
        NavigationStack(path: $path) {
            // Основной контент (сториз + синяя карточка)
            RouteContent(
                fromTitle: viewModel.from.displayTitle ?? "Откуда",
                toTitle:   viewModel.to.displayTitle   ?? "Куда",
                canSearch: viewModel.canSearch,
                onTapFrom: { showFromFlow = true },
                onTapTo:   { showToFlow   = true },
                onSearch:  {
                    carriersVM.titleFrom = viewModel.from.displayTitle ?? ""
                    carriersVM.titleTo   = viewModel.to.displayTitle   ?? ""

                    let fromCode = viewModel.fromCodeForSearch ?? ""
                    let toCode   = viewModel.toCodeForSearch   ?? ""

                    carriersVM.configureRoute(fromCode: fromCode, toCode: toCode)
                    path.append(.carriers)                    // один раз!
                },
                stories: stories,                             // <-- массив сториз
                onOpenStory: { idx in                         // <-- открытие плеера
                    storyIndex  = idx
                    showStories = true
                    storyStore.markSeen(stories[idx].id)      // сразу помечаем просмотренной
                },
                storyStore: storyStore                        // <-- общий Store (ObservedObject)
            )


            .navigationDestination(for: RouteNav.self) { dest in
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
                        onApply: { newFilter in
                            carriersVM.updateFilter(newFilter)
                            path.removeLast() // аккуратный pop назад к списку
                        }
                    )

                case let .carrierDetails(item):
                    CarrierDetailsView(item: item)
                }
            }
            .fullScreenCover(isPresented: $showStories) {
                StoryPlayerView(
                    stories: stories,
                    startIndex: storyIndex,
                    onSeen: { i in
                        storyStore.markSeen(stories[i].id)   // ← помечаем при авто/ручном переходе
                    },
                    onClose: {
                        showStories = false
                    }
                )
            }
        }
        // Полноэкранные флоу выбора города → станции (перекрывают TabBar)
        .fullScreenCover(isPresented: $showFromFlow) {
            CityStationFlowView(
                mode: .from,
                initialCities: mockCities,
                stationsProvider: mockStations(for:),
                onFinish: { city, station in
                    viewModel.setFromCity(title: city.title, code: city.id)
                    viewModel.setFromStation(title: station.title, code: station.id)
                }
            )
        }
        .fullScreenCover(isPresented: $showToFlow) {
            CityStationFlowView(
                mode: .to,
                initialCities: mockCities,
                stationsProvider: mockStations(for:),
                onFinish: { city, station in
                    viewModel.setToCity(title: city.title, code: city.id)
                    viewModel.setToStation(title: station.title, code: station.id)
                }
            )
        }
        // Своп местами (кнопка со стрелками в RouteContent)
        .onReceive(NotificationCenter.default.publisher(for: .init("swapRoutePlaces"))) { _ in
            viewModel.swapPlaces()
        }
    }
}
