
import SwiftUI

// Кастомная кнопка «назад» без текста
struct BackChevron: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button { dismiss() } label: {
            Image(systemName: "chevron.left")
                .imageScale(.large)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.primary)
        }
        .buttonStyle(.plain)
    }
}

// HEX → Color
extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(.sRGB,
                  red:   Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8)  & 0xFF) / 255,
                  blue:  Double( hex        & 0xFF) / 255,
                  opacity: alpha)
    }
}

let accentBlue = Color(red: 0.22, green: 0.45, blue: 0.91)
let redNote    = Color(red: 0.96, green: 0.42, blue: 0.42)
