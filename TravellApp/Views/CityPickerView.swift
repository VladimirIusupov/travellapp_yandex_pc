// CityPickerView.swift
import SwiftUI

struct CityPickerView: View {
    @ObservedObject var viewModel: CityPickerViewModel
    let onPick: (CityRow) -> Void

    var body: some View {
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
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.tertiary)
                        }
                        .frame(height: 60)
                        .padding(.horizontal, 16)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .background(Color(.systemBackground))
        .searchable(text: $viewModel.query,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Введите запрос")
        .onChange(of: viewModel.query) { _ in
            viewModel.updateFilter()
        }
    }
}
