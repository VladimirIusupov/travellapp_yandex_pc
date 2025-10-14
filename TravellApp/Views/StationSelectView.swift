import SwiftUI

struct StationSelectView: View {
    @ObservedObject var viewModel: StationSelectViewModel
    let onPick: (StationItem) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(viewModel.filtered) { station in
                Button {
                    onPick(station)
                    dismiss()
                } label: {
                    Text(station.title)
                }
            }
            .searchable(text: $viewModel.query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Поиск станции")
            .onChange(of: viewModel.query) { _ in viewModel.onQueryChange() }
            .navigationTitle(viewModel.cityTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    StationSelectView(
        viewModel: .init(
            cityTitle: "Москва",
            stations: [
                .init(id: "s1", title: "Ленинградский вокзал"),
                .init(id: "s2", title: "Казанский вокзал"),
                .init(id: "s3", title: "Курский вокзал")
            ]
        ),
        onPick: { _ in }
    )
}

