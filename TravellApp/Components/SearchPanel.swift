import SwiftUI

// MARK: - Search Panel
struct SearchPanel: View {
    
    // MARK: - Bindings
    @Binding var from: String
    @Binding var to: String
    
    // MARK: - Callbacks
    let onSwap: () -> Void
    let onFromTap: () -> Void
    let onToTap: () -> Void
    
    // MARK: - Body
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ypBlue)
                .frame(height: 128)
            
            VStack(spacing: 0) {
                
                Button(action: onFromTap) {
                    Text(from.isEmpty ? "Откуда" : from)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(from.isEmpty ? .ypGrey : .black)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .frame(height: 48)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                Button(action: onToTap) {
                    Text(to.isEmpty ? "Куда" : to)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(to.isEmpty ? .ypGrey : .ypBlackUniversal)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .frame(height: 48)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ypWhiteUniversal)
            )
            .padding(.vertical, 16)
            .padding(.leading, 16)
            .padding(.trailing, 68)
        }
        .overlay(alignment: .trailing) {
            Button(action: onSwap) {
                Image("Сhange")
                    .resizable()
                    .frame(width: 36, height: 36)
            }
            .padding(.trailing, 16)
        }
    }
}
