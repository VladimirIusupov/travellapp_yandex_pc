import SwiftUI

struct StoryPageView: View {
    let story: Story
    let index: Int
    let selectedIndex: Int
    let progress: CGFloat
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                Color.black.ignoresSafeArea()
                
                ZStack {
                    
                    Image(story.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                    
                    LinearGradient(colors: [Color.black.opacity(0.55), .clear],
                                   startPoint: .bottom, endPoint: .center)
                    .allowsHitTesting(false)
                    
                    VStack {
                        HStack(spacing: 4) {
                            ForEach(0..<7, id: \.self) { i in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(Color.white.opacity(0.5))
                                    if i == selectedIndex {
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(.ypBlue)
                                            .scaleEffect(x: max(0.001, progress), y: 1, anchor: .leading)
                                            .animation(.linear, value: progress)
                                    } else if i < selectedIndex {
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(.ypBlue)
                                    }
                                }
                                .frame(height: 6)
                            }
                        }
                        .padding(.top, 28)
                        .padding(.horizontal, 12)
                        
                        Spacer()
                    }
                    
                    VStack {
                        Spacer()
                        VStack(alignment: .leading, spacing: 16) {
                            Text(story.title)
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(radius: 4)
                            
                            Text(story.subtitle)
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(.white)
                                .shadow(radius: 4)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 40)
                    }
                }
                
                .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
                
                .overlay(alignment: .topTrailing) {
                    Button(action: { dismiss() }) {
                        Image("closeButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .contentShape(Rectangle())
                    }
                    .padding(.trailing, 12)
                    .padding(.top, 28 + 16)
                }
            }
        }
    }
}
