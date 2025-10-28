import SwiftUI

// MARK: - View
struct StationPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: StationPickerViewModel
    
    let onSelect: (SelectedStation) -> Void
    
    init(cityId: String, onSelect: @escaping (SelectedStation) -> Void) {
        _viewModel = StateObject(wrappedValue: StationPickerViewModel(cityId: cityId))
        self.onSelect = onSelect
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 17, height: 22)
                        .foregroundStyle(.ypBlack)
                        .background(.ypWhite)
                }
                .padding(.leading, 8)
                .padding(.vertical, 11)
                
                Spacer()
                
                Text("Выбор станции")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.ypBlack)
                    .background(.ypWhite)
                
                Spacer()
                
                Color.clear
                    .frame(width: 17, height: 22)
                    .padding(.trailing, 8)
            }
            .padding(.bottom, 4)
            
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.ypGrey)
                
                TextField("Введите запрос", text: $viewModel.searchText)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .foregroundStyle(.ypBlack)
                    .background(.ypWhite)
                
                if !viewModel.searchText.isEmpty {
                    Button { viewModel.searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.ypGrey)
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(Color("Tertiary"))
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
            } else if viewModel.filteredStations.isEmpty {
                Spacer()
                Text("Станции не найдены")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.ypBlack)
                    .background(.ypWhite)
                Spacer()
            } else {
                List {
                    ForEach(viewModel.filteredStations) { station in
                        Button {
                            onSelect(SelectedStation(code: station.id, title: station.title))
                            dismiss()
                        } label: {
                            HStack {
                                Text(station.title)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(.ypWhite)
                                    .frame(width: 11, height: 19)
                            }
                            .frame(height: 58)
                        }
                        .buttonStyle(.plain)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color("ypWhite"))
                        .background(.ypWhite)
                    }
                }
                .listStyle(.plain)
                .background(.ypWhite)
            }
        }
        .navigationBarHidden(true)
        .task { await viewModel.loadStations() }
        .toolbar(.hidden, for: .tabBar)
        .background(.ypWhite)
    }
}
