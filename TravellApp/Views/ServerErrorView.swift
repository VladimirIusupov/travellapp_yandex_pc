import SwiftUI

struct ServerErrorView: View {
    let message: String
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.octagon.fill").font(.system(size: 56))
                .foregroundStyle(.red)
            Text("Ошибка сервера").font(.title2).bold()
            Text(message).multilineTextAlignment(.center).foregroundStyle(.secondary)
        }
        .padding()
    }
}
