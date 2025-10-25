import SwiftUI

struct StoriesStripView: View {
    let stories: [Story]
    let onOpen: (Int) -> Void
    @ObservedObject var store: StoryStore

    let itemSize: CGSize
    let spacing: CGFloat

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: spacing) {
                ForEach(Array(stories.enumerated()), id: \.1.id) { idx, story in
                    StoryItemView(
                        story: story,
                        isSeen: store.seen.contains(story.id),
                        size: itemSize
                    )
                    .onTapGesture {
                        onOpen(idx)
                        store.markSeen(story.id)
                    }
                }
            }
            .padding(.trailing, 16)
        }
    }
}

private extension Color {
    static let brandBlue = Color(red: 0x37/255, green: 0x72/255, blue: 0xE7/255) // #3772E7
}

private struct StoryItemView: View {
    let story: Story
    let isSeen: Bool
    let size: CGSize

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(story.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .clipped()
                .opacity(isSeen ? 0.45 : 1.0)

            // Заголовок поверх
            Text(story.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(3)
                .shadow(radius: 8)
                .padding(8)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSeen ? Color.clear : .brandBlue, lineWidth: 4) // 5) синяя обводка 4pt
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .frame(width: size.width, height: size.height)
    }
}
