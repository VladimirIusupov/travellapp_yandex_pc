import SwiftUI

struct TimeRowView: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        Button(action: { isOn.toggle() }) {
            HStack {
                Text(title)
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: isOn ? "checkmark.square.fill" : "square")
                    .foregroundStyle(.primary)
                    .font(.system(size: 20))
            }
        }
        .buttonStyle(.plain)
    }
}
