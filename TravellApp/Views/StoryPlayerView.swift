import SwiftUI
import Combine

struct StoryPlayerView: View {
    let stories: [Story]
    @State private var index: Int
    let onClose: () -> Void
    let onSeen: ((Int) -> Void)?

    // ТАЙМЕР
    @State private var progress: Double = 0
    @State private var timer: AnyCancellable?

    // КОНСТАНТЫ
    private let corner: CGFloat = 28

    // ProgressBar
    private let barHeight: CGFloat   = 6
    private let barHPad: CGFloat     = 12
    private let barTopInset: CGFloat = 35

    // Close (крестик)
    private let closeSize: CGFloat    = 30
    private let closeTrailing: CGFloat = 12
    private let closeGapFromBar: CGFloat = 16

    // Тексты
    private let textHPad: CGFloat = 16
    private let textBottomFromSafe: CGFloat = 57
    private let textSpacing: CGFloat = 20
    
    // Картинка
    private let imageBottomInset: CGFloat = 17

    init(stories: [Story], startIndex: Int, onSeen: ((Int) -> Void)? = nil, onClose: @escaping () -> Void) {
        self.stories = stories
        self._index  = State(initialValue: min(max(0, startIndex), stories.count - 1))
        self.onSeen  = onSeen
        self.onClose = onClose
    }

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            

            ZStack {
                // 0) ФОН
                Color("ypBlackUniversal").ignoresSafeArea()

                // 1) КАРТИНКА (закруглена, full width, привязана к низу; снизу 17)
                let imageHeight = h - imageBottomInset
                Image(stories[index].imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: w, height: imageHeight, alignment: .top)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
                    .position(x: w/2, y: h - imageBottomInset - imageHeight/2)
                    .allowsHitTesting(false)

                // 2) ТЕКСТЫ (внутри экрана, слева/справа 16, до safe area снизу 57)
                VStack(alignment: .leading, spacing: textSpacing) {
                    Text(stories[index].title)
                        .font(.system(size: 34, weight: .bold))
                        .kerning(0.4)
                        .foregroundStyle(Color(.ypWhiteUniversal))
                        .lineLimit(2)

                    Text(stories[index].subtitle)
                        .font(.system(size: 20, weight: .regular))
                        .kerning(0.4)
                        .foregroundStyle(Color(.ypWhiteUniversal))
                        .lineLimit(4)
                }
                .padding(.horizontal, textHPad)
                .padding(.bottom, textBottomFromSafe)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .zIndex(1)

                // 3) ВЕРХНИЙ СЛОЙ: ProgressBar + Крестик + зоны тапа
                VStack(spacing: 0) {
                    // ProgressBar: по 12 слева/справа, сверху 35 от safe area
                    SegmentsFullWidth(
                        itemsCount: stories.count,
                        currentIndex: index,
                        currentProgress: progress,
                        height: barHeight
                    )
                    .padding(.horizontal, barHPad)
                    .padding(.top, barTopInset)

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .zIndex(3)

                // Крестик: 16 ниже ProgressBar, справа 12
                Button {
                    stopTimer()
                    onClose()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: closeSize, height: closeSize)
                        .background(Circle().fill(Color("ypBlackUniversal")))
                }
                .padding(.trailing, closeTrailing)
                .padding(.top, barTopInset + barHeight + closeGapFromBar)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .zIndex(10)

                // Тап-зоны по краям (всегда поверх)
                HStack(spacing: 0) {
                    Color.black.opacity(0.001)
                        .contentShape(Rectangle())
                        .onTapGesture { prev() }
                    Color.black.opacity(0.001)
                        .contentShape(Rectangle())
                        .onTapGesture { nextOrClose() }
                }
                .ignoresSafeArea()
                .zIndex(5)
            }
        }
        .onAppear { startTimer() }
        .onDisappear { stopTimer() }
        .simultaneousGesture(
            DragGesture(minimumDistance: 20).onEnded { v in
                if v.translation.height > 40 { stopTimer(); onClose() }
            }
        )
    }
}

// MARK: - Логика таймера и навигации

private extension StoryPlayerView {
    func nextOrClose() {
        if index < stories.count - 1 {
            index += 1
            restartTimer()
        } else {
            stopTimer()
            onClose()
        }
    }
    func prev() {
        if index > 0 {
            index -= 1
            restartTimer()
        }
    }
    func startTimer() {
        stopTimer()
        onSeen?(index)
        let duration = max(0.1, stories[index].duration)
        progress = 0
        timer = Timer.publish(every: 0.02, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                progress += 0.02 / duration
                if progress >= 1 { nextOrClose() }
            }
    }
    func stopTimer() { timer?.cancel(); timer = nil }
    func restartTimer() { startTimer() }
}

// MARK: - Прогресс-бар

private struct SegmentsFullWidth: View {
    let itemsCount: Int
    let currentIndex: Int
    let currentProgress: Double
    let height: CGFloat
    private let spacing: CGFloat = 6

    var body: some View {
        GeometryReader { proxy in
            let totalWidth   = proxy.size.width
            let totalSpacing = spacing * CGFloat(max(itemsCount - 1, 0))
            let segmentWidth = (totalWidth - totalSpacing) / CGFloat(max(itemsCount, 1))

            HStack(spacing: spacing) {
                ForEach(0..<itemsCount, id: \.self) { i in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.white)
                        Capsule().fill(Color("ypBlue"))
                            .frame(width: segmentWidth * CGFloat(fill(i)))
                    }
                    .frame(width: segmentWidth, height: height)
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
