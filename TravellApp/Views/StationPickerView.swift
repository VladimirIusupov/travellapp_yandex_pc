import SwiftUI

struct StationPickerView: View {
    let cityTitle: String
    @ObservedObject var viewModel: StationPickerViewModel
    let onPick: (StationRow) -> Void

    var body: some View {
        List {
            ForEach(viewModel.filtered) { station in
                Button {
                    onPick(station)
                } label: {
                    HStack {
                        Text(station.title)
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.footnote)
                            .foregroundStyle(.tertiary)
                    }
                }
                .buttonStyle(.plain)
            }
            .listRowSeparator(.visible)
        }
        .listStyle(.plain)
        .safeAreaInset(edge: .top) {
            SearchBar(placeholder: "Введите запрос", text: $viewModel.query)
                .onChange(of: viewModel.query) { _ in viewModel.updateFilter() }
        }
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        StationPickerView(
            cityTitle: "Москва",
            viewModel: .init(stations: [
                .init(id: "kiev", title: "Киевский вокзал"),
                .init(id: "kursk", title: "Курский вокзал"),
                .init(id: "yar", title: "Ярославский вокзал")
            ]),
            onPick: { _ in }
        )
    }
}
