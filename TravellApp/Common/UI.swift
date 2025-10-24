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
