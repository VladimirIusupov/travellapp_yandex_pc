import SwiftUI

// Кастомная кнопка «назад» без текста
struct BackChevron: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)               
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(Color("ypWhite"))
        .accessibilityLabel("Назад")
    }
}
