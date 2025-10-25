import SwiftUI

// MARK: - CarriersListView

struct CarriersListView: View {
    @ObservedObject var viewModel: CarriersListViewModel
    @EnvironmentObject private var theme: ThemeManager

    // Навигация
    var onOpenFilters: () -> Void
    var onOpenDetails: (CarrierItem) -> Void

    private enum UI {
        static let side: CGFloat = 16
        static let betweenCards: CGFloat = 8
        static let titleTop: CGFloat = 8
        static let titleFont = Font.system(size: 24, weight: .bold)
        static let bottomBtnH: CGFloat = 60
        static let bottomBtnBottom: CGFloat = 24
    }

    private var pageBackground: Color { theme.isDarkTheme ? .black : Color(.ypWhite) }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Заголовок
                    Text("\(viewModel.titleFrom) → \(viewModel.titleTo)")
                        .font(UI.titleFont)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, UI.titleTop)
                        .padding(.horizontal, UI.side)

                    // Карточки: 16 слева/справа, 8 между, 16 от заголовка
                    LazyVStack(spacing: UI.betweenCards) {
                        ForEach(Array(viewModel.filtered.enumerated()), id: \.element.id) { idx, item in
                            Button {
                                onOpenDetails(item)
                            } label: {
                                CarrierCard(
                                    item: item,
                                    rightDate: mockDate(forIndex: idx) // временно, пока нет даты из API
                                )
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, UI.side)
                        }
                    }
                    .padding(.bottom, UI.bottomBtnH + UI.bottomBtnBottom + 12) // место под кнопку
                }
            }
            .background(pageBackground)

            // Кнопка «Уточнить время»
            Button(action: onOpenFilters) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ypBlue)
                    .frame(height: UI.bottomBtnH)
                    .overlay {
                        DotText("Уточнить время",
                                showDot: isFilterApplied(viewModel.filter),
                                dotColor: .ypRed)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    }
            }
            .buttonStyle(.plain)
            .padding(.horizontal, UI.side)
            .padding(.bottom, UI.bottomBtnBottom)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackChevron()
                    .padding(.leading, -8)
            }
        }
        .task { await viewModel.ensureLoaded() }
    }

    // Простой мок-дата справа (замените на реальную, когда появится)
    private func mockDate(forIndex i: Int) -> String {
        let day = 14 + (i % 3) // 14/15/16 января для демонстрации
        return "\(day) января"
    }
}

private struct CarrierCard: View {
    let item: CarrierItem
    var rightDate: String? = nil

    private enum UI {
        static let height: CGFloat = 104
        static let corner: CGFloat = 28
        static let logoSide: CGFloat = 44
        static let logoPad: CGFloat = 14
        static let headerLeft: CGFloat = logoPad + logoSide + 12
        static let headerTop: CGFloat = 14
        static let tlSide: CGFloat = 14
        static let tlBottom: CGFloat = 14
        static let lineWidth: CGFloat = 1
        static let lineOpacity: CGFloat = 0.3
    }

    var body: some View {
        let hasSubtitle = (item.subtitle?.isEmpty == false)
        let titleSubtitleSpacing: CGFloat = hasSubtitle ? 6 : 0
        let headerBottom: CGFloat = hasSubtitle ? 28 : 40
        let headerTop = UI.headerTop + (hasSubtitle ? 0 : 10)

        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: UI.corner, style: .continuous)
                .fill(Color(.ypLightGrey))

            item.logoImage
                .resizable()
                .scaledToFit()
                .frame(width: UI.logoSide, height: UI.logoSide)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.leading, UI.logoPad)
                .padding(.top, UI.logoPad)

            VStack(alignment: .leading, spacing: titleSubtitleSpacing) {
                HStack(alignment: .firstTextBaseline) {
                    Text(item.name)
                        .font(.system(size: 17, weight: .regular))
                        .kerning(-0.41)
                        .foregroundColor(Color(.ypBlackUniversal))
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Spacer(minLength: 8)

                    if let date = rightDate {
                        Text(date)
                            .font(.system(size: 12, weight: .regular))
                            .kerning(0.4)
                            .foregroundColor(Color(.ypBlackUniversal))
                            .lineLimit(1)
                    }
                }

                if hasSubtitle, let st = item.subtitle {
                    Text(st)
                        .font(.system(size: 12, weight: .regular))
                        .kerning(-0.41)
                        .foregroundColor(.ypRed)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .padding(EdgeInsets(top: 1, leading: 0, bottom: 3, trailing: 0))
                }

                Spacer(minLength: 0)
            }
            .padding(.leading, UI.headerLeft)
            .padding(.trailing, UI.tlSide)
            .padding(.top, headerTop)          // ← используем вычисленный отступ
            .padding(.bottom, headerBottom)

            HStack(alignment: .center, spacing: 12) {
                Text(item.depTime)
                    .font(.system(size: 17, weight: .regular))
                    .kerning(-0.41)
                    .foregroundColor(Color(.ypBlackUniversal))

                timelineLine

                Text(item.duration)
                    .font(.system(size: 12, weight: .regular))
                    .kerning(0.4)
                    .foregroundColor(Color(.ypBlackUniversal))

                timelineLine

                Text(item.arrTime)
                    .font(.system(size: 17, weight: .regular))
                    .kerning(-0.41)
                    .foregroundColor(Color(.ypBlackUniversal))
            }
            .padding(.horizontal, UI.tlSide)
            .padding(.bottom, UI.tlBottom)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
        .frame(height: UI.height)
        .shadow(color: .black.opacity(0.05), radius: 4, y: 1)
    }

    private var timelineLine: some View {
        Rectangle()
            .fill(Color(.ypBlackUniversal).opacity(UI.lineOpacity))
            .frame(height: UI.lineWidth)
            .frame(maxWidth: .infinity)
    }
}



// MARK: - Хелперы/утилиты

private func isFilterApplied(_ f: CarriersFilter) -> Bool {
    f.morning || f.day || f.evening || f.night || (f.withTransfers != nil)
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

private extension CarrierItem {
    var logoImage: Image {
        if UIImage(named: logoSystemName) != nil {
            return Image(logoSystemName)
        } else {
            return Image(systemName: logoSystemName)
        }
    }
}

#if DEBUG
import SwiftUI

// Отдельная карточка — варианты
#Preview("CarrierCard – with/without transfer") {
    VStack(spacing: 12) {
        CarrierCard(
            item: .init(
                logoSystemName: "rzd",          // ассет или SF Symbol
                name: "РЖД",
                subtitle: "С пересадкой в Костроме",
                depTime: "06:10",
                arrTime: "14:55",
                duration: "9 часов"
            ),
            rightDate: "14 января"
        )
        .padding(.horizontal, 16)

        CarrierCard(
            item: .init(
                logoSystemName: "fgk",
                name: "ФГК",
                subtitle: nil,
                depTime: "07:45",
                arrTime: "16:20",
                duration: "9 часов"
            ),
            rightDate: "15 января"
        )
        .padding(.horizontal, 16)
    }
    .padding(.vertical, 12)
    .background(Color(.systemBackground))
    .previewLayout(.sizeThatFits)
}

// Экран списка — светлая тема
#Preview("CarriersListView – light") {
    let vm = CarriersListViewModel(titleFrom: "Москва", titleTo: "Санкт-Петербург", useMocks: true)
    vm.all = CarriersListViewModel.mockCarriers
    vm.updateFilter(.init()) // без фильтров → filtered = all

    return NavigationStack {
        CarriersListView(
            viewModel: vm,
            onOpenFilters: {},
            onOpenDetails: { _ in }
        )
    }
    .environmentObject(ThemeManager()) // ваш менеджер темы
}

// Экран списка — тёмная тема
#Preview("CarriersListView – dark") {
    let vm = CarriersListViewModel(titleFrom: "Москва", titleTo: "Санкт-Петербург", useMocks: true)
    vm.all = CarriersListViewModel.mockCarriers
    vm.updateFilter(.init())

    let theme = ThemeManager()
    theme.isDarkTheme = true

    return NavigationStack {
        CarriersListView(
            viewModel: vm,
            onOpenFilters: {},
            onOpenDetails: { _ in }
        )
    }
    .environmentObject(theme)
    .preferredColorScheme(.dark)
}
#endif

