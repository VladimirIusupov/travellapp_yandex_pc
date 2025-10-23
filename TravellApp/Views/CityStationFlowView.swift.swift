import SwiftUI

struct CityStationFlowView: View {
    enum Mode { case from, to }

    let mode: Mode
    let initialCities: [CityRow]
    let stationsProvider: (CityRow) -> [StationRow]
    let onFinish: (_ city: CityRow, _ station: StationRow) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var path: [FlowDest] = []

    enum FlowDest: Hashable {
        case stations(city: CityRow)
    }

    var body: some View {
        NavigationStack(path: $path) {
            // 1) Корневой экран выбора города
            CityPickerView(
                viewModel: .init(cities: initialCities),
                onPick: { city in
                    path.append(.stations(city: city))
                }
            )
            .navigationTitle("Выбор города")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackChevron()
                }
            }

            // 2) Экран выбора станции
            .navigationDestination(for: FlowDest.self) { dest in
                switch dest {
                case let .stations(city):
                    StationPickerView(
                        cityTitle: city.title,
                        viewModel: .init(stations: stationsProvider(city)),
                        onPick: { st in
                            onFinish(city, st)
                            dismiss()
                        }
                    )
                    .navigationTitle("Выбор станции")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(false)              
                }
            }
        }
        .interactiveDismissDisabled()
    }
}
