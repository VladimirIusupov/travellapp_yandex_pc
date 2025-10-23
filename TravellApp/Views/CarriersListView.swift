import SwiftUI

// MARK: - CarriersListView

struct CarriersListView: View {
    @ObservedObject var viewModel: CarriersListViewModel

    /// открыть фильтры
    let onOpenFilters: () -> Void
    /// открыть карточку перевозчика
    let onOpenDetails: (CarrierItem) -> Void

    @Environment(\.dismiss) private var dismiss

    private let blue = Color(hex: 0x3772E7)

    var body: some View {
        ZStack {
            // Основной контент
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Заголовок 24 Bold, многострочный
                    Text("\(viewModel.titleFrom) → \(viewModel.titleTo)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 8)
                        .padding(.horizontal, 16)

                    // Список карточек
                    VStack(spacing: 16) {
                        ForEach(viewModel.filtered) { item in
                            Button {
                                onOpenDetails(item)
                            } label: {
                                CarrierRow(item: item)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)      // слева/справа по 16
                    .padding(.bottom, 120)         // запас под плавающую кнопку
                }
            }

            // Плавающая кнопка «Уточнить время»
            VStack {
                Spacer()
                filterButton
                    .padding(.horizontal, 16)
                    .padding(.bottom, 58) // отступ от низа по макету
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Кнопка «Назад» без текста, цвет сам адаптируется к теме
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                }
            }
        }
        .toolbar(.hidden, for: .tabBar) // скрыть TabBar на экране списка
        .task { await viewModel.ensureLoaded() }
    }

    // MARK: Views

    private var filterButton: some View {
        Button {
            onOpenFilters()
        } label: {
            HStack(spacing: 8) {
                Spacer()
                Text("Уточнить время")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                if viewModel.filter.isActive {
                    Circle()
                        .fill(Color(hex: 0xF56B6C)) // индикатор активных фильтров
                        .frame(width: 8, height: 8)
                        .accessibilityHidden(true)
                }
                Spacer()
            }
        }
        .frame(height: 60)
        .background(blue)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
        .buttonStyle(.plain)
    }
}

// MARK: - Ячейка перевозчика

private struct CarrierRow: View {
    let item: CarrierItem

    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                // Логотип в «пилюле»
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.white)
                    Image(systemName: item.logoSystemName)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color(hex: 0xF44336)) // условный красный логотип
                }
                .frame(width: 48, height: 36)

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.system(size: 17, weight: .regular)) // Regular 17
                        .foregroundStyle(.primary)

                    if let subtitle = item.subtitle, !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(Color(hex: 0xF56B6C))
                    }
                }

                Spacer()

                // (По макету может быть дата справа — опционально)
            }

            // Таймлайн
            HStack(alignment: .center, spacing: 12) {
                Text(item.depTime)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.primary)

                SeparatorLine()

                Text(item.duration)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.secondary)

                SeparatorLine()

                Text(item.arrTime)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.primary)
            }
        }
        .frame(height: 104) // высота ячейки
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(hex: 0xEEEEEE)) // фон карточки
        )
    }
}

private struct SeparatorLine: View {
    var body: some View {
        Rectangle()
            .fill(Color.primary.opacity(0.12))
            .frame(height: 1)
            .frame(maxWidth: .infinity)
    }
}

// MARK: - Вспомогательные расширения

extension CarriersFilter {
    /// Признак, что пользователь применил хотя бы один фильтр
    var isActive: Bool {
        morning || day || evening || night || withTransfers != nil
    }
}

extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xff) / 255.0
        let g = Double((hex >> 8)  & 0xff) / 255.0
        let b = Double(hex & 0xff) / 255.0
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}
