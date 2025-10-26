import SwiftUI

struct TransferRowView: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(title)
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundStyle(.primary)
                    .font(.system(size: 20))
            }
        }
        .buttonStyle(.plain)
    }
}
