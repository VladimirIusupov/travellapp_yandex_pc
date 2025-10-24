import SwiftUI

struct CityStationFlowView: View {
    enum Mode { case from, to }

    let mode: Mode
    let initialCities: [CityRow]
    let stationsProvider: (CityRow) -> [StationRow]
    let onFinish: (_ city: CityRow, _ station: StationRow) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var path: [FlowDest] = []

    enum FlowDest: Hashable { case stations(city: CityRow) }

    var body: some View {
        NavigationStack(path: $path) {
            CityPickerView(
                viewModel: .init(cities: initialCities),
                onPick: { path.append(.stations(city: $0)) }
            )
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { BackChevron() }
                ToolbarItem(placement: .principal) {
                    Text("Выбор города")
                        .font(.system(size: 17, weight: .bold))   // Bold 17
                        .kerning(0)                                // letter-spacing: 0
                        .foregroundStyle(Color("ypBlack"))
                }
            }
            .background(Color("ypWhite").ignoresSafeArea())
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
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) { BackChevron() }
                        ToolbarItem(placement: .principal) {
                            Text("Выбор станции")
                                .font(.system(size: 17, weight: .bold)) // Bold 17
                                .kerning(0)
                                .foregroundStyle(Color("ypBlack"))
                        }
                    }
                    .background(Color("ypWhite").ignoresSafeArea())
                }
            }
        }
        .interactiveDismissDisabled()
        .background(Color("ypWhite").ignoresSafeArea())
    }
}
