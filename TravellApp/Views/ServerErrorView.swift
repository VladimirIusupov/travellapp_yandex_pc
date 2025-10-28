import SwiftUI

struct ServerErrorView: View {
    var message: String = ""               
    var onRetry: (() -> Void)? = nil
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            VStack(spacing: 24) {
                Image("img_server_error")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 48, style: .continuous))
                    .shadow(color: .black.opacity(0.06), radius: 10, y: 4)

                Text("Ошибка сервера")
                    .font(.title2.weight(.semibold))

                if !message.isEmpty {
                    Text(message)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
            }
        }
    }
}
