import SwiftUI

struct NoInternetView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 24) {
                Image("img_no_internet")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 48, style: .continuous))
                    .shadow(color: .black.opacity(0.06), radius: 10, y: 4)

                Text("Нет интернета")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
