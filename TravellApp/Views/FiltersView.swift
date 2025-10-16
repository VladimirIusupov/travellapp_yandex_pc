// Features/Filters/FiltersView.swift
import SwiftUI

struct FiltersView: View {
    @State private var model: CarriersFilter
    let onApply: (CarriersFilter) -> Void

    init(initial: CarriersFilter, onApply: @escaping (CarriersFilter) -> Void) {
        _model = State(initialValue: initial)
        self.onApply = onApply
    }

    var body: some View {
        Form {
            Section("Время отправления") {
                Toggle("Утро 06:00 - 12:00", isOn: $model.morning)
                Toggle("День 12:00 - 18:00", isOn: $model.day)
                Toggle("Вечер 18:00 - 00:00", isOn: $model.evening)
                Toggle("Ночь 00:00 - 06:00", isOn: $model.night)
            }
            Section("Показывать варианты с пересадками") {
                RadioRow(title: "Да", isSelected: Binding(
                    get: { model.withTransfers == true },
                    set: { if $0 { model.withTransfers = true } }
                ))
                RadioRow(title: "Нет", isSelected: Binding(
                    get: { model.withTransfers == false },
                    set: { if $0 { model.withTransfers = false } }
                ))
                RadioRow(title: "Не важно", isSelected: Binding(
                    get: { model.withTransfers == nil },
                    set: { if $0 { model.withTransfers = nil } }
                ))
            }
        }
        .navigationTitle("Фильтрация")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Применить") { onApply(model) }   // ⛔️ без dismiss здесь
            }
        }
    }
}

private struct RadioRow: View {
    let title: String
    @Binding var isSelected: Bool

    var body: some View {
        Button {
            isSelected = true
        } label: {
            HStack {
                Text(title).foregroundStyle(.primary)
                Spacer()
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .imageScale(.large)
            }
        }
        .buttonStyle(.plain)
    }
}
