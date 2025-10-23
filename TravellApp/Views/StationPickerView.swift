// StationPickerView.swift
import SwiftUI

struct StationPickerView: View {
    let cityTitle: String
    @ObservedObject var viewModel: StationPickerViewModel
    let onPick: (StationRow) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.filtered) { station in
                    Button {
                        onPick(station)
                    } label: {
                        HStack(spacing: 8) {
                            Text(station.title)
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
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
    }
}
