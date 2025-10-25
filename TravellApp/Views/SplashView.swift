import SwiftUI

struct SplashView: View {
    @ObservedObject var viewModel: SplashViewModel

    var body: some View {
        ZStack {
            Image("logo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            if viewModel.showProgress {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.large)
                    .tint(.white.opacity(0.9))
            }
        }
        .statusBarHidden(true)
        .task { await viewModel.onAppear() }
    }
}
