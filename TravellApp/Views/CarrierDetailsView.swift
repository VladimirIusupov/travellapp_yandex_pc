import SwiftUI

struct CarrierDetailsView: View {
    let item: CarrierItem

    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    // Цвета макета
    private let accentBlue = Color(red: 0.22, green: 0.45, blue: 0.91) // #3772E7

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Контейнер с логотипом — ВСЕГДА белый, отступы по 16, высота 104
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.06), radius: 6, y: 2)

                        Image(systemName: item.logoSystemName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 56)
                            .foregroundColor(.red)
                    }
                    .frame(height: 104)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    // Название компании — 24 Bold
                    Text(item.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 16)

                    // Контакты
                    VStack(alignment: .leading, spacing: 24) {
                        contactBlock(title: "E-mail",
                                     value: "i.lozgkina@yandex.ru",
                                     action: { openURL(URL(string: "mailto:i.lozgkina@yandex.ru")!) })

                        contactBlock(title: "Телефон",
                                     value: "+7 (904) 329-27-71",
                                     action: { openURL(URL(string: "tel://+79043292771")!) })
                    }
                    .padding(.horizontal, 16)

                    Spacer(minLength: 24)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                        .padding(8)
                        .background(.thinMaterial, in: Circle())
                }
                .accessibilityLabel("Назад")
            }

            ToolbarItem(placement: .principal) {
                Text("Информация о перевозчике")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)
            }
        }
        // таб-бар на карточке тоже скрыт
        .toolbar(.hidden, for: .tabBar)
    }

    // MARK: - UI Helpers

    private func contactBlock(title: String, value: String, action: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 17)) // Regular 17
                .foregroundColor(.primary)

            Button(action: action) {
                Text(value)
                    .font(.system(size: 12)) // Regular 12, letter-spacing ~ 0.4
                    .kerning(0.4)
                    .foregroundColor(accentBlue)
            }
            .buttonStyle(.plain)
        }
    }
}
