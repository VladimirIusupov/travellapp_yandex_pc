import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var theme: ThemeManager
    @State private var showAgreement = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: $theme.isDarkTheme) {
                        Text("Тёмная тема")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(.primary)
                    }
                    .tint(accentBlue)
                }
                .listRowBackground(Color(.secondarySystemGroupedBackground))

                Section {
                    Button {
                        showAgreement = true
                    } label: {
                        HStack {
                            Text("Пользовательское соглашение")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .listRowBackground(Color(.secondarySystemGroupedBackground))
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Настройки")
            // ПРИКЛЕЕННЫЙ НИЖНИЙ ФУТЕР — всегда у низа экрана
            .safeAreaInset(edge: .bottom) {
                footer
                    .background(.clear)    // не перекрашиваем фон
                    .padding(.bottom, 8)   // лёгкая «подушка» над home-баром
            }
        }
        // оферта — полноэкранно, перекрывает TabBar
        .fullScreenCover(isPresented: $showAgreement) {
            AgreementWebView(urlString: "https://yandex.ru/legal/practicum_offer")
                .ignoresSafeArea()
        }
    }

    private var footer: some View {
        VStack(spacing: 8) {
            Text("Приложение использует API «Яндекс.Расписания»")
                .font(.footnote)
                .foregroundStyle(.secondary)
            Text("Версия 1.0 (beta)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
