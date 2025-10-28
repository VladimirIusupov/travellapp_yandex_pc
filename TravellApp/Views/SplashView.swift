import SwiftUI

// MARK: - View
struct SplashView: View {
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(.ypBlackUniversal).ignoresSafeArea()
            Image("logo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}
