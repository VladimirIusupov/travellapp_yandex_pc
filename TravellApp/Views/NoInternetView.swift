import SwiftUI

struct NoInternetView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "wifi.slash").font(.system(size: 56))
                .foregroundStyle(.orange)
            Text("Нет интернета").font(.title2).bold()
            Text("Проверьте подключение и попробуйте снова.")
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}
