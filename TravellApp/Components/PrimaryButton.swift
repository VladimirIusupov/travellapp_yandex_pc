import SwiftUI

struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.ypBlue.cornerRadius(12))
            .foregroundStyle(.ypWhiteUniversal)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
