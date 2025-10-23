import SwiftUI

struct CarriersListView: View {
    @ObservedObject var viewModel: CarriersListViewModel

    // Навигационные действия
    var onOpenFilters: () -> Void
    var onOpenDetails: (CarrierItem) -> Void

    // MARK: - UI константы
    private let screenPadding: CGFloat = 16
    private let titleFont = Font.system(size: 24, weight: .bold) // по макету
    private let bottomButtonHeight: CGFloat = 60
    private let bottomButtonBottom: CGFloat = 58

    // красная точка при активном фильтре
    private var hasActiveFilters: Bool {
        let f = viewModel.filter
        return f.morning || f.day || f.evening || f.night || (f.withTransfers != nil)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Заголовок
                    Text("\(viewModel.titleFrom) → \(viewModel.titleTo)")
                        .font(titleFont)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 8)
                        .padding(.horizontal, screenPadding)

                    // Список карточек
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.filtered) { item in
                            Button {
                                onOpenDetails(item)
                            } label: {
                                CarrierCard(item: item)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, screenPadding)
                        }
                    }
                    .padding(.top, 0)
                    .padding(.bottom, bottomButtonHeight + bottomButtonBottom + 12) // место под кнопку
                }
            }

            // Кнопка «Уточнить время»
            VStack {
                Spacer()
                Button {
                    onOpenFilters()
                } label: {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(accentBlue)
                        .frame(height: 60)
                        .overlay {
                            DotText(
                                "Уточнить время",
                                showDot: isFilterApplied(viewModel.filter),
                                dotColor: (redNote)
                            )
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                        }
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.bottom, 58)
            }
            .padding(.horizontal, screenPadding)
            .padding(.bottom, bottomButtonBottom)
        }
        // Скрываем TabBar на этом экране
        .toolbar(.hidden, for: .tabBar)
        // Кастомная кнопка «назад» без текста
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackChevron()
            }
        }
        // Первая загрузка
        .task {
            await viewModel.ensureLoaded()
        }
    }
}

// MARK: - Карточка перевозчика (всегда «светлая»)
private struct CarrierCard: View {
    let item: CarrierItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Лого
            Image(systemName: item.logoSystemName)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(Color(hex: 0xF56B6C))
                .frame(width: 44, height: 44)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            // Тексты
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline) {
                    Text(item.name)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.black)
                    Spacer()
                }

                if let subtitle = item.subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(Color(hex: 0xF56B6C))
                        .lineLimit(1)
                }

                // Таймлайн
                HStack(spacing: 12) {
                    Text(item.depTime)
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(.black)

                    TimelineSeparator()

                    Text(item.duration) // тот же цвет, что у времени
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.black)

                    TimelineSeparator()

                    Text(item.arrTime)
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(.black)
                }
            }
        }
        .frame(height: 104, alignment: .center) // высота карточки
        .padding(16)
        .background(Color.white)                  // ВСЕГДА белая
        .environment(\.colorScheme, .light)       // и «светлая» палитра внутри
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 1)
    }
}

private func isFilterApplied(_ f: CarriersFilter) -> Bool {
    f.morning || f.day || f.evening || f.night || (f.withTransfers != nil)
}

private struct TimelineSeparator: View {
    var body: some View {
        Rectangle()
            .fill(Color.black.opacity(0.2))
            .frame(height: 1)
            .frame(maxWidth: .infinity)
    }
}

private struct DotText: View {
    let text: String
    let showDot: Bool
    let dotColor: Color

    init(_ text: String, showDot: Bool, dotColor: Color) {
        self.text = text
        self.showDot = showDot
        self.dotColor = dotColor
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Text(text)
            if showDot {
                Circle()
                    .fill(dotColor)
                    .frame(width: 8, height: 8)
                    .offset(x: 12, y: 8)
                    .accessibilityHidden(true)
            }
        }
    }
}
