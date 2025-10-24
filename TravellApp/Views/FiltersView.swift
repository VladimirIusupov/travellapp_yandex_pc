import SwiftUI

struct FiltersView: View {
    let initial: CarriersFilter
    let onApply: (CarriersFilter) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var filter: CarriersFilter

    init(initial: CarriersFilter, onApply: @escaping (CarriersFilter) -> Void) {
        self.initial = initial
        self.onApply = onApply
        _filter = State(initialValue: initial)
    }

    private enum UI {
        static let sideLeft: CGFloat  = 16
        static let sideRight: CGFloat = 18
        static let sectionTitleTop: CGFloat = 8
        static let interBlock: CGFloat = 16
        static let rowHeight: CGFloat = 60
        static let applyHeight: CGFloat = 60
        static let applyBottom: CGFloat = 24
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: UI.interBlock) {

                    // Заголовок 1
                    SectionTitle("Время отправления")
                        .padding(.top, 16)

                    // Секция времени: 4 ряда по 60, чекбокс слева
                    VStack(spacing: 0) {
                        CheckBox(title: "Утро 06:00 – 12:00", isOn: $filter.morning)
                        CheckBox(title: "День 12:00 – 18:00",  isOn: $filter.day)
                        CheckBox(title: "Вечер 18:00 – 00:00", isOn: $filter.evening)
                        CheckBox(title: "Ночь 00:00 – 06:00",  isOn: $filter.night)
                    }

                    // 16 до второго заголовка
                    SectionTitle("Показывать варианты с пересадками")

                    // Радио «Да/Нет» — по 60//
                    VStack() {
                        RadioRowFixedHeight(
                            title: "Да",
                            isSelected: filter.withTransfers == true,
                            onTap: { filter.withTransfers = true }
                        )
                        RadioRowFixedHeight(
                            title: "Нет",
                            isSelected: filter.withTransfers == false,
                            onTap: { filter.withTransfers = false }
                        )
                    }
                }
                .padding(.leading, UI.sideLeft)
                .padding(.trailing, UI.sideRight)
                .background(Color("ypWhite"))
            }
            .background(Color("ypWhite"))

            // Кнопка «Применить»
            BottomApplyButton(
                title: "Применить",
                height: UI.applyHeight,
                bottom: UI.applyBottom
            ) {
                onApply(filter)
            }
            .padding(.bottom, 24)
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) { BackChevron() }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

// MARK: - Заголовок секции

private struct SectionTitle: View {
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View {
        Text(text)
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(.primary)
    }
}

// MARK: - Кнопка внизу

private struct BottomApplyButton: View {
    let title: String
    let height: CGFloat
    let bottom: CGFloat
    let action: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Button(action: action) {
                HStack {
                    Spacer()
                    Text(title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                    Spacer()
                }
                .frame(height: height)
                .background(Color(.ypBlue))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 16)      // 16 слева/справа
            .padding(.bottom, bottom)      // 24 от safe area
        }
    }
}

// MARK: - Ряды времени: чекбокс слева, 60pt

private struct CheckBox: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Button { isOn.toggle() } label: {
            HStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Checkbox(isOn: isOn)
                    .frame(width: 24, height: 24)
            }
            .contentShape(Rectangle())
            .frame(height: 60)
        }
        .buttonStyle(.plain)
    }
}

private struct Checkbox: View {
    let isOn: Bool
    @Environment(\.colorScheme) private var scheme

    private var boxFillOn: Color { scheme == .dark ? .ypWhiteUniversal : .ypBlackUniversal }
    private var boxFillOff: Color { scheme == .dark ? .ypBlackUniversal : .ypWhiteUniversal }
    private var borderColor: Color { scheme == .dark ? .ypWhiteUniversal : .ypBlackUniversal }
    private var checkColor: Color { scheme == .dark ? .ypBlackUniversal : .ypWhiteUniversal }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(isOn ? boxFillOn : boxFillOff)
                .overlay(
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .stroke(borderColor, lineWidth: 1)
                )
                .frame(width: 20, height: 20)

            if isOn {
                Image(systemName: "checkmark")
                    .font(.system(size: 15, weight: .heavy))
                    .foregroundStyle(checkColor)
            }
        }
        .accessibilityHidden(true)
    }
}

// MARK: - Радио-ряды: 60pt, отступы 16 по краям контейнера

private struct RadioRowFixedHeight: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Radio(isSelected: isSelected)
                    .frame(width: 26, height: 26)
            }
            .contentShape(Rectangle())
            .frame(height: 60)                 // фикс. высота секции
        }
        .buttonStyle(.plain)
    }
}


// Радиокнопка — белый круг с чёрным контуром, активная с чёрной точкой
private struct Radio: View {
    let isSelected: Bool
    @Environment(\.colorScheme) private var scheme

    private var outerFill: Color { scheme == .dark ? .ypBlackUniversal : .ypWhiteUniversal }
    private var borderColor: Color { scheme == .dark ? .ypWhiteUniversal : .ypBlackUniversal }
    private var dotColor: Color { scheme == .dark ? .ypWhiteUniversal : .ypBlackUniversal }

    var body: some View {
        ZStack {
            Circle()
                .fill(outerFill)
                .overlay(Circle().stroke(borderColor, lineWidth: 2))
                .frame(width: 20, height: 20)

            if isSelected {
                Circle()
                    .fill(dotColor)
                    .frame(width: 10, height: 10)
            }
        }
        .accessibilityHidden(true)
    }
}


#if DEBUG
import SwiftUI

#Preview("Filters – default (light)") {
    NavigationStack {
        FiltersView(initial: .init(), onApply: { _ in })
    }
}

#Preview("Filters – selected (dark)") {
    var f = CarriersFilter()
    f.morning = true
    f.evening = true
    f.withTransfers = true

    return NavigationStack {
        FiltersView(initial: f, onApply: { _ in })
    }
    .preferredColorScheme(.dark)
}

/// Вспомогательный контейнер для превью со стейтом
private struct StatefulPreview<Content: View, Value>: View {
    @State private var value: Value
    private let contentBuilder: (Binding<Value>) -> Content

    init(initial: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        self._value = State(initialValue: initial)
        self.contentBuilder = content
    }

    init(@ViewBuilder content: @escaping (Binding<Value>) -> Content) where Value == Bool {
        self._value = State(initialValue: false)
        self.contentBuilder = content
    }

    var body: some View { contentBuilder($value) }
}
#endif
