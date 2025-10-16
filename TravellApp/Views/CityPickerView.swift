import SwiftUI

struct CityPickerView: View {
    @ObservedObject var viewModel: CityPickerViewModel
    let onPick: (CityRow) -> Void

    var body: some View {
        List {
            ForEach(viewModel.filtered) { city in
                Button {
                    onPick(city)
                } label: {
                    HStack {
                        Text(city.title)
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
        .overlay {
            if viewModel.filtered.isEmpty && !viewModel.query.isEmpty {
                VStack {
                    Spacer(minLength: 120)
                    Text("Город не найден")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
        }
        .navigationTitle("Выбор города")
        .navigationBarTitleDisplayMode(.inline)
    }
}
