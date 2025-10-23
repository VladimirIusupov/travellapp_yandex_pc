import SwiftUI

struct FiltersView: View {
    // Входные данные и колбэк
    let initial: CarriersFilter
    let onApply: (CarriersFilter) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var filter: CarriersFilter

    private let blue = Color(hex: 0x3772E7)

    init(initial: CarriersFilter, onApply: @escaping (CarriersFilter) -> Void) {
        self.initial = initial
        self.onApply = onApply
        _filter = State(initialValue: initial)
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // Заголовок секции
                    Text("Время отправления")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.primary)
                        .padding(.top, 8)

                    Group {
                        CheckRow(title: "Утро 06:00 – 12:00", isOn: $filter.morning)
                        CheckRow(title: "День 12:00 – 18:00",  isOn: $filter.day)
                        CheckRow(title: "Вечер 18:00 – 00:00", isOn: $filter.evening)
                        CheckRow(title: "Ночь 00:00 – 06:00",  isOn: $filter.night)
                    }

                    // Разделитель между блоками (16пт)
                    Spacer().frame(height: 16)

                    Text("Показывать варианты с пересадками")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.primary)

                    // Радиогруппа Да/Нет
                    VStack(spacing: 16) {
                        RadioRow(
                            title: "Да",
                            isSelected: Binding(
                                get: { filter.withTransfers == true },
                                set: { new in filter.withTransfers = new ? true : (filter.withTransfers == false ? false : true) }
                            )
                        )
                        RadioRow(
                            title: "Нет",
                            isSelected: Binding(
                                get: { filter.withTransfers == false },
                                set: { new in filter.withTransfers = new ? false : (filter.withTransfers == true ? true : false) }
                            )
                        )
                    }

                    // Отступ под кнопку
                    Spacer().frame(height: 120)
                }
                .padding(.leading, 16)
                .padding(.trailing, 18) // справа 18 по макету
            }

            // Плавающая кнопка «Применить»
            VStack {
                Spacer()
                Button {
                    onApply(filter)
                } label: {
                    HStack {
                        Spacer()
                        Text("Применить")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .frame(height: 60)
                    .background(blue)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.bottom, 58)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

// MARK: - Строка с чекбоксом

private struct CheckRow: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.primary)
                Spacer()
                Checkbox(isOn: isOn)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

private struct Checkbox: View {
    let isOn: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .strokeBorder(isOn ? .clear : Color.primary.opacity(0.25), lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(isOn ? Color.primary : .clear)
                )
                .frame(width: 26, height: 26)
            if isOn {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .accessibilityHidden(true)
    }
}

// MARK: - Строка с радиокнопкой

private struct RadioRow: View {
    let title: String
    @Binding var isSelected: Bool

    var body: some View {
        Button {
            isSelected = true
        } label: {
            HStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.primary)
                Spacer()
                Radio(isSelected: isSelected)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

private struct Radio: View {
    let isSelected: Bool
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.primary.opacity(0.25), lineWidth: 2)
                .frame(width: 26, height: 26)
            if isSelected {
                Circle()
                    .stroke(Color.primary, lineWidth: 2)
                    .frame(width: 26, height: 26)
                    .overlay(
                        Circle()
                            .fill(Color.primary)
                            .frame(width: 10, height: 10)
                    )
            }
        }
        .accessibilityHidden(true)
    }
}
