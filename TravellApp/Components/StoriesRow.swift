import SwiftUI

struct StoriesRow: View {
    let story: Story
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            Image(story.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .opacity(story.isViewed ? 0.5 : 1.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(story.isViewed ? Color.clear : .ypBlue, lineWidth: 3)
                )
            
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.6), .clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Text(story.title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .padding(6)
                .lineLimit(3)
        }
        .frame(width: 100, height: 150)
    }
}
