import SwiftUI

struct StationPickerView: View {
    let cityTitle: String
    @ObservedObject var viewModel: StationPickerViewModel
    let onPick: (StationRow) -> Void

    var body: some View {
        VStack(spacing: 0) {
            SearchBar(placeholder: "Введите запрос", text: $viewModel.query)
            // Список станций
            ScrollView {
                LazyVStack(spacing: 0) { // без расстояния между ячейками
                    ForEach(viewModel.filtered) { station in
                        Button {
                            onPick(station)
                        } label: {
                            HStack(spacing: 8) {
                                Text(station.title)
                                    .font(.system(size: 18, weight: .regular)) // SF Pro Regular 17
                                    .kerning(-0.41)
                                    .foregroundStyle(Color("ypBlack"))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Spacer(minLength: 8)
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)                // 24×24
                                    .foregroundStyle(Color("ypBlack").opacity(0.6))
                            }
                            .frame(height: 60)
                            .padding(.horizontal, 16)
                            .padding(.top, 4)
                            .background(Color("ypWhite"))
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .background(Color("ypWhite"))
        }
        .background(Color("ypWhite").ignoresSafeArea())
        .onChange(of: viewModel.query) { _ in viewModel.updateFilter() }
    }
}
