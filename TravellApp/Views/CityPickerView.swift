import SwiftUI

// MARK: - View
struct CityPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CityPickerViewModel()
    
    let onSelect: (City) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 17, height: 22)
                        .foregroundStyle(.ypBlack)
                }
                .padding(.leading, 8)
                .padding(.vertical, 11)
                
                Spacer()
                
                Text("Выбор города")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.ypBlack)
                
                Spacer()
                
                Color.clear.frame(width: 17, height: 22)
                    .padding(.trailing, 8)
            }
            .padding(.bottom, 4)
            .background(.ypWhite)
            
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.ypGrey)
                TextField("Введите запрос", text: $viewModel.searchText)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .foregroundStyle(.ypBlack)
                if !viewModel.searchText.isEmpty {
                    Button { viewModel.searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.ypGrey)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(.ypTertiary)
            .cornerRadius(10)
            .padding(.horizontal, 16)
            .padding(.bottom, 8)

            
            if viewModel.isLoading {
                Spacer()
                ProgressView("Загрузка...")
                Spacer()
            } else if let appError = viewModel.appError {
                Spacer()
                ErrorView(type: appError.errorType)
                Spacer()
            } else if viewModel.filteredCities.isEmpty {
                Spacer()
                Text("Город не найден")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.ypBlack)
                Spacer()
            } else {
                List {
                    ForEach(viewModel.filteredCities) { city in
                        Button { onSelect(city) } label: {
                            HStack {
                                Text(city.title)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(.ypBlack)
                                    .frame(width: 11, height: 19)
                            }
                            .frame(height: 58)
                            .contentShape(Rectangle())
                            .scrollContentBackground(.hidden)
                            .background(.ypWhite)
                        }
                        .buttonStyle(.plain)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color("ypWhite"))
                        .background(.ypWhite)
                    }
                    .background(.ypWhite)
                }
                .listStyle(.plain)
                .background(.ypWhite)
            }
        }
        .navigationBarHidden(true)
        .task { await viewModel.loadCities() }
        .background(.ypWhite)
    }
}
