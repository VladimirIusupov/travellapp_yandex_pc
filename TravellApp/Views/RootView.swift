import SwiftUI

struct RootView: View {
    @AppStorage("appTheme") private var appTheme: String = AppTheme.light.rawValue
    @State private var showMain = false
    
    var body: some View {
        ZStack {
            if showMain {
                MainTabView()
            } else {
                SplashView()
            }
        }
        .preferredColorScheme(appTheme == AppTheme.dark.rawValue ? .dark : .light)
        .task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            withAnimation {
                showMain = true
            }
        }
        
    }
}

#Preview {
    RootView()
}
