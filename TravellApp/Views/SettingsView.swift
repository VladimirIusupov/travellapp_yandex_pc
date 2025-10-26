import SwiftUI

// MARK: - View
struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            
            if viewModel.isLoading {
                Spacer()
                ProgressView("Загрузка...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .background(Color(.ypWhite))
                Spacer()
            } else if let appError = viewModel.appError {
                
                Spacer()
                ErrorView(type: appError.errorType)
                Spacer()
            } else {
                
                VStack(spacing: 0) {
                    
                    HStack {
                        Text("Тёмная тема")
                            .font(.system(size: 17))
                            .foregroundStyle(.primary)
                        Spacer()
                        Toggle("", isOn: viewModel.isDarkMode)
                            .labelsHidden()
                            .tint(.blue)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    
                    Button(action: { viewModel.openAgreement() }) {
                        HStack {
                            Text("Пользовательское соглашение")
                                .font(.system(size: 17))
                                .foregroundStyle(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(.ypBlackUniversal)
                                .frame(width: 11, height: 19)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)
                }
                .background(Color(.ypWhite).ignoresSafeArea())
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.top, 16)
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("Приложение использует API Яндекс.Расписания")
                        .font(.system(size: 12))
                        .foregroundStyle(.ypBlackUniversal)
                    Text("Версия 1.0 (beta)")
                        .font(.system(size: 12))
                        .foregroundStyle(.ypBlackUniversal)
                }
                .padding(.bottom, 16)
                .background(Color(.ypWhite).ignoresSafeArea())
            }
        }
        .background(Color(.ypWhite).ignoresSafeArea())
        .fullScreenCover(isPresented: $viewModel.showAgreement) {
            AgreementWebView(urlString: "https://yandex.ru/legal/practicum_offer")
                .toolbar(.hidden, for: .tabBar)
        }
        .background(Color(.ypWhite).ignoresSafeArea())
        .task {
            await viewModel.loadSettings()
        }
    }
}
