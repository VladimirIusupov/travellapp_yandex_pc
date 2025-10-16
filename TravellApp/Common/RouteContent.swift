import SwiftUI

struct RouteContent: View {
    let fromTitle: String
    let toTitle: String
    let canSearch: Bool
    let onTapFrom: () -> Void
    let onTapTo: () -> Void
    let onSearch: () -> Void

    // Константы под макет
    private let inset: CGFloat = 16        // внутренние отступы синей области
    private let blueCorner: CGFloat = 28
    private let whiteCorner: CGFloat = 20
    private let changeSize: CGFloat = 44
    private let whiteHeight: CGFloat = 100 // высота белого блока
    private let gap: CGFloat = 16          // зазор между белым блоком и кнопкой

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Откуда")
                    .font(.largeTitle).bold()
                    .padding(.horizontal)

                // Сториз
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(0..<6, id: \.self) { _ in
                            StoryCardView(imageName: nil, title: "Text Text\nText Text T…")
                        }
                    }
                    .padding(.horizontal)
                }

                // Карточка выбора направлений
                HStack(spacing: gap) {
                    // Белая область ввода станций — фикс. 100pt
                    VStack(spacing: 0) {
                        Button(action: onTapFrom) { row(fromTitle) }
                            .buttonStyle(.plain)
                            .frame(height: whiteHeight / 2)

                        Divider()

                        Button(action: onTapTo) { row(toTitle) }
                            .buttonStyle(.plain)
                            .frame(height: whiteHeight / 2)
                    }
                    .frame(height: whiteHeight)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: whiteCorner, style: .continuous))
                    .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
                    .environment(\.colorScheme, .light)

                    // Кнопка смены маршрута (Change)
                    Button {
                        NotificationCenter.default.post(name: .init("swapRoutePlaces"), object: nil)
                    } label: {
                        Image(systemName: "arrow.2.squarepath")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.blue)
                            .frame(width: changeSize, height: changeSize)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.08), radius: 6, y: 2)
                    }
                    .accessibilityLabel("Change")
                }
                // Внутренние 16 от синей области: слева/справа/сверху/снизу
                .padding(.all, inset)
                .background(
                    RoundedRectangle(cornerRadius: blueCorner, style: .continuous)
                        .fill(Color.blue) // поставьте AccentColor = #3772E7 в Assets для точного цвета
                )
                .padding(.horizontal)

                // СРАЗУ под синей карточкой
                if canSearch {
                    Button(action: onSearch) {
                        Text("Найти")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 160, height: 60)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous)) // ← 16
                            .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity) // центрируем по экрану
                    .padding(.top, 16)          // ← ЯВНО 16 от карточки
                }

                Spacer(minLength: 24)
            }
            .padding(.top, 8)
        }
    }

    // Ряд внутри белого блока
    private func row(_ text: String) -> some View {
        HStack {
            Text(text)
                .foregroundStyle((text == "Откуда" || text == "Куда") ? .gray : .primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Spacer()
        }
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
    }
}

#Preview {
    RouteContent(
        fromTitle: "Москва (Курский вокзал)",
        toTitle: "Санкт Петербург (Балтийский вокзал)",
        canSearch: true,
        onTapFrom: {},
        onTapTo: {},
        onSearch: {}
    )
}
