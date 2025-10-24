import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var theme: ThemeManager
    @State private var showAgreement = false
    
    private let rowHeight: CGFloat = 60
    private let sideInset: CGFloat = 16
    
    var body: some View {
        ZStack {
            Color("ypWhite").ignoresSafeArea()
            VStack(spacing: 0) {
                Color.clear.frame(height: 24)
                List {
                    // Строка: Тёмная тема
                    HStack {
                        Text("Тёмная тема")
                            .font(.system(size: 17, weight: .regular))
                            .kerning(-0.41)
                            .foregroundColor(Color("ypBlack"))
                        Spacer(minLength: sideInset)
                        Toggle("", isOn: $theme.isDarkTheme)
                            .labelsHidden()
                            .tint(Color("ypBlue"))
                    }
                    .frame(height: rowHeight)
                    .listRowInsets(EdgeInsets(top: 0, leading: sideInset, bottom: 0, trailing: sideInset))
                    .listRowBackground(Color("ypWhite"))
                    
                    // Строка: Пользовательское соглашение
                    Button {
                        showAgreement = true
                    } label: {
                        HStack {
                            Text("Пользовательское соглашение")
                                .font(.system(size: 17, weight: .regular))
                                .kerning(-0.41)
                                .foregroundColor(Color("ypBlack"))
                            Spacer(minLength: sideInset)
                            Image(systemName: "chevron.right")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color("ypBlack"))
                        }
                        .frame(height: rowHeight)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .listRowInsets(EdgeInsets(top: 0, leading: sideInset, bottom: 0, trailing: sideInset))
                    .listRowBackground(Color("ypWhite"))
                }
                .listStyle(.plain)
                .listRowSeparator(.hidden)
                .listSectionSpacing(0)
                .scrollContentBackground(.hidden)
                .background(Color("ypWhite"))
            }
            // Футер снизу
            .safeAreaInset(edge: .bottom) {
                footer
                    .padding(.horizontal, sideInset)
                    .padding(.bottom, 24)
                    .background(Color("ypWhite"))
            }
        }
        .preferredColorScheme(theme.isDarkTheme ? .dark : .light)
        .fullScreenCover(isPresented: $showAgreement) {
            AgreementWebView(urlString: "https://yandex.ru/legal/practicum_offer")
                .preferredColorScheme(theme.isDarkTheme ? .dark : .light)
                .ignoresSafeArea()
        }
    }
    
    // MARK: - Footer (44pt)
    private var footer: some View {
        ZStack {
            Color.clear.frame(height: 44)
            VStack(spacing: 16) { // ← было 2, стало 16
                Text("Приложение использует API «Яндекс.Расписания»")
                Text("Версия 1.0 (beta)")
            }
            .font(.system(size: 12, weight: .regular))
            .kerning(0.4)
            .foregroundColor(Color("ypBlack"))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
        }
    }
}
