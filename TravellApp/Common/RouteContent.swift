import SwiftUI

struct RouteContent: View {
    // Параметры экрана
    let fromTitle: String
    let toTitle: String
    let canSearch: Bool
    let onTapFrom: () -> Void
    let onTapTo: () -> Void
    let onSearch: () -> Void

    // NEW: Stories
    let stories: [Story]
    let onOpenStory: (_ index: Int) -> Void
    let storyStore: StoryStore


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

                // Сториз (горизонтальная лента)
                StoriesStripView(stories: stories, onOpen: onOpenStory, store: storyStore)

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
                    .environment(\.colorScheme, .light) // читаемый текст в тёмной теме

                    // Кнопка смены маршрута
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
                .padding(.all, inset) // внутренние 16 от синей области
                .background(
                    RoundedRectangle(cornerRadius: blueCorner, style: .continuous)
                        .fill(Color.blue)
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
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity) // центрируем по ширине
                    .padding(.top, 16)          // отступ от синей карточки = 16
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
