import SwiftUI

struct StoryCardView: View {
    let imageName: String?
    let title: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                if let name = imageName, UIImage(named: name) != nil {
                    Image(name)
                        .resizable()
                        .scaledToFill()
                } else {
                    // заглушка, если нет ассетов
                    Rectangle().fill(Color.gray.opacity(0.2))
                        .overlay(Image(systemName: "train.side.front.car").font(.largeTitle))
                }
            }
            .frame(width: 120, height: 170)
            .clipped()
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.blue, lineWidth: 3)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            Text(title)
                .font(.footnote).bold()
                .foregroundStyle(.white)
                .shadow(radius: 4)
                .padding(8)
        }
        .frame(width: 120, height: 170)
    }
}
