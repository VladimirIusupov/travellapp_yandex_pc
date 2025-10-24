import SwiftUI

struct CityPickerView: View {
    @ObservedObject var viewModel: CityPickerViewModel
    let onPick: (CityRow) -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Строка поиска — сразу под заголовком
            SearchBar(placeholder: "Введите запрос", text: $viewModel.query)
            // Список
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.filtered) { city in
                        Button {
                            onPick(city)
                        } label: {
                            HStack(spacing: 8) {
                                Text(city.title)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Spacer(minLength: 8)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundStyle(Color("ypBlack"))
                                    .frame(width: 24, height: 24)
                            }
                            .frame(height: 60)
                            .padding(.horizontal, 16)
                            .padding(.top, 4)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .background(Color("ypWhite"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color("ypWhite"), for: .navigationBar)
        // Обновление фильтра
        .onChange(of: viewModel.query) { _ in viewModel.updateFilter() }
    }
}

private struct ListRowButton<Content: View>: View {
    let height: CGFloat
    let action: () -> Void
    let content: () -> Content

    init(height: CGFloat, action: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.height = height
        self.action = action
        self.content = content
    }

    var body: some View {
        Button(action: action) {
            content()
                .frame(height: height)
                .padding(.horizontal, 16)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
