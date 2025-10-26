import SwiftUI

struct StoriesView: View {
    @ObservedObject var viewModel: StoriesViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let storyDuration: TimeInterval = 3.0
    @State private var progress: CGFloat = 0.0
    @State private var timer: Timer? = nil
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            TabView(selection: $viewModel.selectedIndex) {
                ForEach(viewModel.stories.indices, id: \.self) { index in
                    StoryPageView(
                        story: viewModel.stories[index],
                        index: index,
                        selectedIndex: viewModel.selectedIndex,
                        progress: progress
                    )
                    .tag(index)
                    .onAppear {
                        viewModel.markStoryViewed(at: index)
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .onChange(of: viewModel.selectedIndex) { _ in
            startTimer()
        }
        .onAppear { startTimer() }
        .onDisappear { timer?.invalidate() }
    }
    
    private func startTimer() {
        timer?.invalidate()
        progress = 0.0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { t in
            progress += 0.03 / storyDuration
            if progress >= 1.0 {
                progress = 0.0
                if viewModel.selectedIndex < viewModel.stories.count - 1 {
                    viewModel.selectedIndex += 1
                } else {
                    t.invalidate()
                    dismiss()
                }
            }
        }
    }
}
