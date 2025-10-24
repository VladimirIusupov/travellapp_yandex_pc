import SwiftUI

struct CarrierDetailsView: View {
    let item: CarrierItem

    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    private enum UI {
        static let side: CGFloat = 16
        static let logoHeight: CGFloat = 104
        static let logoCorner: CGFloat = 20
        static let logoImageHeight: CGFloat = 56
        static let titleTop: CGFloat = 8
        static let titleFont = Font.system(size: 24, weight: .bold)
        static let vSpacing: CGFloat = 16
        static let contactsSpacing: CGFloat = 24
        static let bottomSpacer: CGFloat = 24
    }

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: UI.vSpacing) {

                    // Логотип на белой карточке (104pt)
                    LogoCard(
                        image: item.logoImage,
                        imageHeight: UI.logoImageHeight,
                        cornerRadius: UI.logoCorner
                    )
                    .frame(height: UI.logoHeight)
                    .padding(.horizontal, UI.side)
                    .padding(.top, UI.side)

                    // Название компании — 24 Bold
                    Text(item.name)
                        .font(UI.titleFont)
                        .foregroundStyle(.primary)
                        .padding(.horizontal, UI.side)

                    // Контакты
                    VStack(alignment: .leading, spacing: UI.contactsSpacing) {
                        ContactRow(
                            title: "E-mail",
                            value: "i.lozgkina@yandex.ru",
                            action: { openURL(URL(string: "mailto:i.lozgkina@yandex.ru")!) }
                        )
                        ContactRow(
                            title: "Телефон",
                            value: "+7 (904) 329-27-71",
                            action: { openURL(URL(string: "tel://+79043292771")!) }
                        )
                    }
                    .padding(.horizontal, UI.side)

                    Spacer(minLength: UI.bottomSpacer)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { BackChevron() .padding(.leading, -8) }
            ToolbarItem(placement: .principal) {
                Text("Информация о перевозчике")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.primary)
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

// MARK: - Подвью: карточка с логотипом (всегда белая)

private struct LogoCard: View {
    let image: Image
    let imageHeight: CGFloat
    let cornerRadius: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.ypWhiteUniversal)

            image
                .resizable()
                .scaledToFit()
        }
    }
}

// MARK: - Подвью: строка контакта

private struct ContactRow: View {
    let title: String
    let value: String
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.primary)

            Button(action: action) {
                Text(value)
                    .font(.system(size: 12, weight: .regular))
                    .kerning(0.4)
                    .foregroundStyle(.ypBlue)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Хелпер: ассетный логотип или SF Symbol

private extension CarrierItem {
    var logoImage: Image {
        if UIImage(named: logoSystemName) != nil {
            return Image(logoSystemName)
        } else {
            return Image(systemName: logoSystemName)
        }
    }
}
