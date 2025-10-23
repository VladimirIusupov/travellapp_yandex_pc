import SwiftUI

// Своя кнопка «Назад» для корневого экрана, чтобы не было второй стрелки
struct BackChevron: View {
    var action: () -> Void
    @Environment(\.colorScheme) private var scheme

    init(action: @escaping () -> Void) { self.action = action }

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(scheme == .dark ? .white : Color(hex: "#1A1B22"))
                .padding(8)
                .background(.ultraThinMaterial, in: Circle())
        }
        .accessibilityLabel("Назад")
    }
}

// HEX → Color
extension Color {
    init(hex: String) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if s.hasPrefix("#") { s.removeFirst() }
        var rgb: UInt64 = 0
        Scanner(string: s).scanHexInt64(&rgb)
        self.init(.sRGB,
                  red:   Double((rgb & 0xFF0000) >> 16) / 255,
                  green: Double((rgb & 0x00FF00) >> 8)  / 255,
                  blue:  Double(rgb & 0x0000FF)        / 255,
                  opacity: 1)
    }
}
