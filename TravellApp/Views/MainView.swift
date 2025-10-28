import SwiftUI

// MARK: - View
struct MainView: View {
    
    // MARK: - State
    @StateObject private var viewModel = MainViewModel()
    @StateObject private var storiesViewModel = StoriesViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            ScrollView {
                VStack(spacing: 24) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(storiesViewModel.stories.indices, id: \.self) { index in
                                Button {
                                    storiesViewModel.selectStory(at: index)
                                } label: {
                                    StoriesRow(story: storiesViewModel.stories[index])
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                    
                    SearchPanel(
                        from: $viewModel.fromTitle,
                        to: $viewModel.toTitle,
                        onSwap: { viewModel.swapStations() },
                        onFromTap: { viewModel.goToCityPicker(isFrom: true) },
                        onToTap: { viewModel.goToCityPicker(isFrom: false) }
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    
                    if viewModel.canSearch {
                        NavigationLink(value: Route.searchResults(
                            fromCode: viewModel.fromStation!.code,
                            toCode: viewModel.toStation!.code,
                            fromTitle: viewModel.fromStation!.title,
                            toTitle: viewModel.toStation!.title
                        )) {
                            Text("Найти")
                                .font(.system(size: 17, weight: .bold))
                                .frame(width: 150, height: 60)
                                .background(.ypBlue)
                                .foregroundStyle(.ypWhiteUniversal)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                    }
                    
                    Spacer()
                }
            }
            .background(.ypWhite)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .cityPicker(let isFrom):
                    CityPickerView { city in
                        viewModel.goToStationPicker(
                            cityId: city.id,
                            cityTitle: city.title,
                            isFrom: isFrom
                        )
                    }
                    .toolbar(.hidden, for: .tabBar)
                case .stationPicker(let cityId, let cityTitle, let isFrom):
                    StationPickerView(cityId: cityId) { station in
                        viewModel.selectStation(station, cityTitle: cityTitle, isFrom: isFrom)
                    }
                case .searchResults(let fromCode, let toCode, let fromTitle, let toTitle):
                    SearchResultsView(
                        fromCode: fromCode,
                        toCode: toCode,
                        fromTitle: fromTitle,
                        toTitle: toTitle,
                        path: $viewModel.path
                    )
                    .toolbar(.hidden, for: .tabBar)
                    
                case .carrierInfo(let code):
                    CarrierCardView(carrierCode: code)
                        .toolbar(.hidden, for: .tabBar)
                    
                case .filters:
                    FiltersView { newFilters in
                    }
                    .toolbar(.hidden, for: .tabBar)
                }
            }
            
            .fullScreenCover(isPresented: $storiesViewModel.showStories) {
                StoriesView(viewModel: storiesViewModel)
            }
        }
    }
}
