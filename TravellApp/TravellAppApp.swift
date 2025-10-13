import SwiftUI

@main
struct TravellAppApp: App {
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                MainView()
                    .zIndex(0)

                if showSplash {
                    SplashView {
                        withAnimation {
                            showSplash = false
                        }
                    }
                    .zIndex(1)
                }
            }
        }
    }
}
