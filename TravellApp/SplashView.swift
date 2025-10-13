import SwiftUI

struct SplashView: View {
    @State private var opacity: Double = 0.0
    var onFinished: (() -> Void)? = nil

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            Image("logo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(opacity)
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.2)) {
                opacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    opacity = 0.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onFinished?()
                }
            }
        }
    }
}
