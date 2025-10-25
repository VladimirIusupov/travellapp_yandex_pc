import SwiftUI

// Кастомная кнопка «назад» без текста
struct BackChevron: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)               
                .contentShape(Rectangle())
                .border(Color("ypWhite"), width: 0)
                .background(.ypWhite)
        }
        .buttonStyle(.plain)
        .background(Color("ypWhite"))
        .accessibilityLabel("Назад")
    }
}
