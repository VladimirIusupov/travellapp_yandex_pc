import SwiftUI
import Combine

struct StoryPlayerView: View {
    let stories: [Story]
    @State private var index: Int
    let onClose: () -> Void

    init(stories: [Story], startIndex: Int, onClose: @escaping () -> Void) {
        self.stories = stories
        self._index = State(initialValue: min(max(0, startIndex), stories.count - 1))
        self.onClose = onClose
    }

    @State private var progress: Double = 0
    @State private var timer: AnyCancellable?

    var body: some View {
        ZStack {
            Image(stories[index].imageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // нижний текст
            VStack(alignment: .leading, spacing: 10) {
                Spacer()
                Text(stories[index].title)
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .shadow(radius: 12)
                    .lineLimit(2)
                Text(stories[index].subtitle)
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.92))
                    .lineLimit(4)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 28)
            .background(
                LinearGradient(colors: [.clear, .black.opacity(0.65)],
                               startPoint: .center, endPoint: .bottom)
                .ignoresSafeArea(edges: .bottom)
            )

            // зоны тапа для навигации
            HStack {
                Color.clear.contentShape(Rectangle()).onTapGesture { prev() }
                Color.clear.contentShape(Rectangle()).onTapGesture { nextOrClose() }
            }
            .ignoresSafeArea()
        }
        // прогресс «в край»
        .overlay(alignment: .top) {
            SegmentsFullWidth(itemsCount: stories.count, currentIndex: index, currentProgress: progress)
                .ignoresSafeArea(.container, edges: [.top, .horizontal])
                .padding(.top, 8)
        }
        // крестик
        .overlay(alignment: .topTrailing) {
            Button {
                stopTimer(); onClose()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .padding(.top, 8)
            .padding(.trailing, 12)
        }
        .onAppear { startTimer() }
        .onDisappear { stopTimer() }
        // свайп вниз — закрыть
        .gesture(DragGesture(minimumDistance: 20).onEnded { v in
            if v.translation.height > 40 { stopTimer(); onClose() }
        })
        .statusBarHidden(true)
    }

    private func nextOrClose() {
        if index < stories.count - 1 { index += 1; restartTimer() }
        else { stopTimer(); onClose() }
    }
    private func prev() { if index > 0 { index -= 1; restartTimer() } }
    private func startTimer() {
        stopTimer()
        let duration = max(0.1, stories[index].duration)
        progress = 0
        timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect().sink { _ in
            progress += 0.02 / duration
            if progress >= 1 { nextOrClose() }
        }
    }
    private func stopTimer() { timer?.cancel(); timer = nil }
    private func restartTimer() { startTimer() }
}

// Прогресс «в край-в-край»
private struct SegmentsFullWidth: View {
    let itemsCount: Int
    let currentIndex: Int
    let currentProgress: Double
    private let spacing: CGFloat = 6, height: CGFloat = 3

    var body: some View {
        GeometryReader { proxy in
            let totalWidth = proxy.size.width
            let totalSpacing = spacing * CGFloat(max(itemsCount - 1, 0))
            let segmentWidth = (totalWidth - totalSpacing) / CGFloat(max(itemsCount, 1))
            HStack(spacing: spacing) {
                ForEach(0..<itemsCount, id: \.self) { i in
                    ZStack(alignment: .leading) {
                        Capsule().fill(.white.opacity(0.35))
                        Capsule().fill(.white)
                            .frame(width: segmentWidth * CGFloat(fill(i)))
                    }.frame(width: segmentWidth, height: height)
                }
            }
            .frame(width: totalWidth)
        }
        .frame(height: height)
    }
    private func fill(_ i: Int) -> Double {
        if i < currentIndex { return 1 }
        if i > currentIndex { return 0 }
        return min(max(currentProgress, 0), 1)
    }
}
