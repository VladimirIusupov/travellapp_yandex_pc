import SwiftUI

struct SplashView: View {
    @ObservedObject var viewModel: SplashViewModel

    var body: some View {
        ZStack {
            // 1) Полноэкранная картинка (из ассетов) строго «как в макете»
            Image("logo") // добавь PNG в Assets с именем "splash"
                .resizable()
                .scaledToFill()
                .ignoresSafeArea() // закрываем safe area полностью

            // 2) (Опционально) Если нужен индикатор загрузки поверх
            if viewModel.showProgress {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.large)
                    .tint(.white.opacity(0.9))
            }
        }
        // В сплэше статус-бар, как правило, скрыт
        .statusBarHidden(true)
        .task { await viewModel.onAppear() }
    }
}
