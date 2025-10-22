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
                    }
                }

                Section {
                    Button {
                        showAgreement = true
                    } label: {
                        HStack {
                            Text("Пользовательское соглашение")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section(footer: footer) { EmptyView() }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Настройки")
        }
        // оферта — полноэкранно, перекрывает TabBar
        .fullScreenCover(isPresented: $showAgreement) {
            AgreementWebView(urlString: "https://yandex.ru/legal/practicum_offer")
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
        .padding(.vertical, 8)
    }
}
