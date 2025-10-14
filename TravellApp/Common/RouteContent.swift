import SwiftUI

struct RouteContent: View {
    let fromTitle: String
    let toTitle: String
    let canSearch: Bool
    let onTapFrom: () -> Void
    let onTapTo: () -> Void
    let onSearch: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Откуда")
                    .font(.largeTitle).bold()
                    .padding(.horizontal)

                // Сториз (горизонтальная лента карточек)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(0..<6, id: \.self) { _ in
                            StoryCardView(imageName: nil, title: "Text Text\nText Text T…")
                        }
                    }
                    .padding(.horizontal)
                }

                // Большая синяя карточка выбора направлений
                ZStack {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(Color.blue)
                        .frame(height: 180)

                    HStack(spacing: 12) {
                        VStack(spacing: 14) {
                            VStack(spacing: 0) {
                                Button(action: onTapFrom) { row(fromTitle) }.buttonStyle(.plain)
                                Divider()
                                Button(action: onTapTo)   { row(toTitle)   }.buttonStyle(.plain)
                            }
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
                            .padding(.leading, 20)
                            .padding(.vertical, 20)
                            .environment(\.colorScheme, .light)
                        }

                        // Кнопка обмена местами (по желанию — через Notification)
                        Button {
                            NotificationCenter.default.post(name: .init("swapRoutePlaces"), object: nil)
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.blue)
                                .frame(width: 44, height: 44)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.08), radius: 6, y: 2)
                        }
                        .padding(.trailing, 16)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Spacer(minLength: 24)
            }
            .padding(.top, 8)
        }
        // Кнопка «Найти» у края экрана, появляется только когда выбраны обе станции
        .safeAreaInset(edge: .bottom) {
            if canSearch {
                Button("Найти", action: onSearch)
                    .buttonStyle(.borderedProminent)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }

    // Строка внутри белого блока (плейсхолдер серый, выбранное — обычный)
    private func row(_ text: String) -> some View {
        HStack {
            Text(text)
                .foregroundStyle((text == "Откуда" || text == "Куда") ? .gray : .primary)
            Spacer()
        }
        .padding()
        .contentShape(Rectangle())
    }
}

#Preview {
    RouteContent(
        fromTitle: "Откуда",
        toTitle: "Куда",
        canSearch: true,
        onTapFrom: {},
        onTapTo: {},
        onSearch: {}
    )
}
