import SwiftUI

private extension Color {
    static let brandBlue = Color(red: 0x37/255, green: 0x72/255, blue: 0xE7/255)
}

struct RouteContent: View {
    // Параметры
    let fromTitle: String
    let toTitle: String
    let canSearch: Bool
    let onTapFrom: () -> Void
    let onTapTo: () -> Void
    let onSearch: () -> Void

    // Stories
    let stories: [Story]
    let onOpenStory: (_ index: Int) -> Void
    let storyStore: StoryStore

    // Константы макета
    private let storiesLeftInset: CGFloat = 16
    private let storiesTopSafe: CGFloat   = 24
    private let storiesToSearch: CGFloat  = 44
    private let storiesItemSize           = CGSize(width: 92, height: 140)
    private let storiesSpacing: CGFloat   = 12

    private let blueCorner: CGFloat   = 28
    private let whiteCorner: CGFloat  = 20
    private let innerInset: CGFloat   = 16
    private let whiteHeight: CGFloat  = 96
    private let changeDiameter: CGFloat = 36
    private let changeTrailing: CGFloat = 16
    private let changeVPadding: CGFloat = 46

    private let findButtonSize = CGSize(width: 150, height: 60)
    private let findButtonTop: CGFloat = 16

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // ------ Stories ------
                StoriesStripView(
                    stories: stories,
                    onOpen: onOpenStory,
                    store: storyStore,
                    itemSize: storiesItemSize,
                    spacing: storiesSpacing
                )
                .padding(.leading, storiesLeftInset)
                .padding(.top, storiesTopSafe)

                // ------ Поиск (синяя секция) ------
                VStack(spacing: 0) {
                    HStack(spacing: 16) {
                        // Белый блок «Откуда / Куда»
                        VStack(spacing: 0) {
                            Button(action: onTapFrom) { row(text: fromTitle) }
                                .buttonStyle(.plain)
                                .frame(height: whiteHeight / 2)
                            
                            Divider()
                            
                            Button(action: onTapTo) { row(text: toTitle) }
                                .buttonStyle(.plain)
                                .frame(height: whiteHeight / 2)
                        }
                        .frame(height: whiteHeight)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: whiteCorner, style: .continuous))
                        .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
                        .environment(\.colorScheme, .light)
                        // Кнопка смены маршрута
                        Button {
                            NotificationCenter.default.post(name: .init("swapRoutePlaces"), object: nil)
                        } label: {
                            Image(systemName: "arrow.2.squarepath")
                                .symbolRenderingMode(.monochrome)
                                .font(.system(size: 18, weight: .regular))
                                .foregroundStyle(Color.brandBlue)
                                .frame(width: 36, height: 36)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.08), radius: 6, y: 2)
                        }
                        .accessibilityLabel("Поменять местами")
                    }
                    .padding(.leading, innerInset)
                    .padding(.trailing, changeTrailing)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: blueCorner, style: .continuous)
                            .fill(Color.brandBlue)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, storiesToSearch)
                }
                // ------ Кнопка «Найти» ------
                if canSearch {
                    Button(action: onSearch) {
                        Text("Найти")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: findButtonSize.width, height: findButtonSize.height)
                            .background(Color.brandBlue)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .padding(.top, findButtonTop)
                }

                Spacer(minLength: 24)
            }
        }
    }

    private func row(text: String) -> some View {
        HStack(spacing: 8) {
            Text(text)
                .font(.system(size: 17, weight: .regular))
                .kerning(-0.41/17.0)
                .foregroundStyle((text == "Откуда" || text == "Куда") ? .gray : .primary)
                .lineLimit(1)                 
                .truncationMode(.tail)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
    }
}
