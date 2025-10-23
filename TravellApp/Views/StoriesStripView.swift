import SwiftUI

struct StoriesStripView: View {
    let stories: [Story]
    let onOpen: (Int) -> Void

    @ObservedObject var store: StoryStore

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(Array(stories.enumerated()), id: \.1.id) { idx, story in
                    StoryItemView(story: story, isSeen: store.seen.contains(story.id))
                        .onTapGesture {
                            onOpen(idx)
                            store.markSeen(story.id)     // ← помечаем просмотренной
                        }
                        .onTapGesture {
                        onOpen(idx)                     // открыть с выбранной
                        store.markSeen(story.id)        // пометить просмотренной
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

private struct StoryItemView: View {
    let story: Story
    let isSeen: Bool

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(story.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 132, height: 196)
                .clipped()
                .opacity(isSeen ? 0.45 : 1.0)         // просмотренные тусклее
                .overlay(alignment: .bottomLeading) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(story.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .lineLimit(3)
                            .shadow(radius: 10)
                    }
                    .padding(10)
                }
                .background(Color.black)

        }
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(isSeen ? Color.clear : Color.blue, lineWidth: 6) // непросмотренные с синей обводкой
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .frame(width: 132, height: 196)
    }
}
