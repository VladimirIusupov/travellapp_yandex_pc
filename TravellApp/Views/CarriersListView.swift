import SwiftUI

struct CarriersListView: View {
    @ObservedObject var viewModel: CarriersListViewModel
    let onOpenFilters: () -> Void
    let onOpenDetails: (CarrierItem) -> Void

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Заголовок: крупный, многострочный
                    Text(titleText)
                        .font(.system(size: 32, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .lineSpacing(2)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                    // Список карточек
                    if viewModel.filtered.isEmpty {
                        Text("Вариантов нет")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 60)
                            .padding(.horizontal, 20)
                    } else {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.filtered) { item in
                                CarrierCard(item: item) {
                                    onOpenDetails(item)
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }

                    Spacer(minLength: 120) // запас под нижнюю кнопку
                }
            }

            // Спиннер при первой загрузке
            if !viewModel.didLoadOnce && viewModel.filtered.isEmpty {
                ProgressView().scaleEffect(1.15)
            }
        }
        // Загружаем данные один раз при заходе на экран
        .task { await viewModel.ensureLoaded() }

        // Нижняя кнопка «Уточнить время» — как в макете
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                Button(action: onOpenFilters) {
                    Text("Уточнить время")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                .buttonStyle(.borderedProminent)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .shadow(color: Color.black.opacity(0.12), radius: 12, y: 6)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .background(.clear)
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var titleText: String {
        let from = viewModel.titleFrom.isEmpty ? "Откуда" : viewModel.titleFrom
        let to   = viewModel.titleTo.isEmpty   ? "Куда"   : viewModel.titleTo
        return "\(from) → \(to)"
    }
}

// MARK: - Карточка перевозчика

private struct CarrierCard: View {
    let item: CarrierItem
    let onTap: () -> Void

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                // Верхняя строка: логотип + название + (справа) дата
                HStack(alignment: .top, spacing: 12) {
                    logo

                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.name)
                            .font(.headline)
                            .foregroundStyle(.primary)

                        if let subtitle = item.subtitle, !subtitle.isEmpty {
                            Text(subtitle)
                                .font(.subheadline)
                                .foregroundStyle(Color.red) // по макету
                        }
                    }

                    Spacer(minLength: 8)

                    // Справа дата (если появится в модели — см. itemDateRight)
                    if let date = itemDateRight {
                        Text(date)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.top, 2)
                    }
                }

                // Нижняя «временная» строка с разделителями
                timeline(dep: item.depTime, duration: item.duration, arr: item.arrTime)
            }
            .padding(16)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .shadow(color: (scheme == .light ? .black.opacity(0.08) : .black.opacity(0.55)),
                    radius: (scheme == .light ? 6 : 10), y: 2)
        }
        .buttonStyle(.plain)
    }

    // Логотип внутри светлого прямоугольника с большим скруглением
    private var logo: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.systemGray6))
                .frame(width: 56, height: 56)
            Image(systemName: item.logoSystemName)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .foregroundStyle(.red)
        }
        .accessibilityHidden(true)
    }

    // Светлая карточная подложка (в тёмной теме остаётся светлой)
    private var cardBackground: some View {
        let bg = Color(uiColor: .secondarySystemBackground)
        return RoundedRectangle(cornerRadius: 28, style: .continuous)
            .fill(bg)
    }

    // Поддержка даты справа (если добавишь её в CarrierItem как `dateText: String?`)
    private var itemDateRight: String? {
        // верни item.dateText, когда поле появится в модели
        nil
    }

    // Разметка нижней строки
    private func timeline(dep: String, duration: String, arr: String) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Text(dep)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.primary)
                .fixedSize()

            line

            Text(duration)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .fixedSize()

            line

            Text(arr)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.primary)
                .fixedSize()
        }
    }

    private var line: some View {
        Rectangle()
            .fill(Color.secondary.opacity(0.35))
            .frame(height: 1)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
    }
}
