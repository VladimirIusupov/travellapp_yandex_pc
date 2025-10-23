import SwiftUI
import Combine

// MARK: - Helpers

/// Верхние скругления кадра Stories
private struct TopRounded: Shape {
    let radius: CGFloat
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let r = min(radius, min(rect.width, rect.height) / 2)
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY + r))
        p.addQuadCurve(to: CGPoint(x: rect.minX + r, y: rect.minY),
                       control: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX - r, y: rect.minY))
        p.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + r),
                       control: CGPoint(x: rect.maxX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

/// Измеряем нижнюю границу верхнего HUD (прогресс + крестик), чтобы зоны тапа не зависели от модели
private struct TopHUDMaxYKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

private extension Color {
    static let brandBlue = Color(red: 0x37/255, green: 0x72/255, blue: 0xE7/255) // #3772E7
    static let closeBg   = Color(red: 0x1A/255, green: 0x1B/255, blue: 0x22/255) // #1A1B22
}

// MARK: - StoryPlayerView

struct StoryPlayerView: View {
    let stories: [Story]
    @State private var index: Int
    let onClose: () -> Void
    let onSeen: ((Int) -> Void)? // вызывается при показе истории

    init(
        stories: [Story],
        startIndex: Int,
        onSeen: ((Int) -> Void)? = nil,
        onClose: @escaping () -> Void
    ) {
        self.stories = stories
        self._index  = State(initialValue: min(max(0, startIndex), stories.count - 1))
        self.onSeen  = onSeen
        self.onClose = onClose
    }

    @State private var progress: Double = 0
    @State private var timer: AnyCancellable?
    @State private var hudMaxY: CGFloat = 0 // нижняя граница HUD, вычисляется из лайаута

    // Константы макета
    private let corner: CGFloat            = 28
    private let barHeight: CGFloat         = 6
    private let barTopInset: CGFloat       = 16    // от Safe Area
    private let barHorizontal: CGFloat     = 12    // слева/справа
    private let crossGapFromBar: CGFloat   = 16    // от прогресса до крестика
    private let crossTrailing: CGFloat     = 12
    private let crossDiameter: CGFloat     = 30
    private let textsHInset: CGFloat       = 16
    private let textsBottomSafe: CGFloat   = 40
    private let textsSpacing: CGFloat      = 16

    var body: some View {
        GeometryReader { proxy in
            let topSafe = proxy.safeAreaInsets.top
            let screenW = proxy.size.width
            let screenH = proxy.size.height

            ZStack {
                // 1) Фон
                Color.black.ignoresSafeArea()

                // 2) Картинка: cover, привязана к верху, скругления верхних углов
                Image(stories[index].imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screenW, height: screenH, alignment: .top)
                    .mask(TopRounded(radius: corner))
                    .clipped()
                    // не залезаем под верхнюю safe-area, чтобы не срезать скругления
                    .ignoresSafeArea(.container, edges: [.bottom])
                    .allowsHitTesting(false)

                // 3) Прогресс-бар (белый трек, синий прогресс) — в край + 12 по бокам, 16 от safe-area
                SegmentsFullWidth(
                    itemsCount: stories.count,
                    currentIndex: index,
                    currentProgress: progress,
                    height: barHeight
                )
                .padding(.horizontal, barHorizontal)
                .padding(.top, topSafe + barTopInset)
                .background(
                    GeometryReader { g in
                        Color.clear.preference(
                            key: TopHUDMaxYKey.self,
                            value: g.frame(in: .named("storyRoot")).maxY
                        )
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                // 4) Текстовые блоки
                VStack(alignment: .leading, spacing: textsSpacing) {
                    Spacer()
                    Text(stories[index].title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .shadow(radius: 12)

                    Text(stories[index].subtitle)
                        .font(.system(size: 15))
                        .foregroundStyle(.white.opacity(0.92))
                        .lineLimit(4)
                }
                .padding(.horizontal, textsHInset)
                .padding(.bottom, textsBottomSafe)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)

                // 5) Градиент у низа
                LinearGradient(colors: [.clear, .black.opacity(0.65)],
                               startPoint: .center, endPoint: .bottom)
                    .allowsHitTesting(false)
                    .ignoresSafeArea(edges: .bottom)
            }
            .coordinateSpace(name: "storyRoot")
            // 6) Крестик — выше всего, размеры/отступы по макету
            .overlay(alignment: .topTrailing) {
                Button {
                    stopTimer()
                    onClose()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: crossDiameter, height: crossDiameter)
                        .background(Circle().fill(Color.closeBg))
                        .background(
                            GeometryReader { g in
                                Color.clear.preference(
                                    key: TopHUDMaxYKey.self,
                                    value: g.frame(in: .named("storyRoot")).maxY
                                )
                            }
                        )                }
                .padding(.trailing, crossTrailing + proxy.safeAreaInsets.trailing)
                .padding(.top, topSafe + barTopInset + barHeight + crossGapFromBar)
            }
            .zIndex(5)
            .overlay {
                GeometryReader { g in
                    let topStart = hudMaxY   // ← без convert(...)
                    VStack(spacing: 0) {
                        Color.clear.frame(height: max(0, topStart))
                        HStack(spacing: 0) {
                            Color.black.opacity(0.001)
                                .contentShape(Rectangle())
                                .onTapGesture { prev() }
                            Color.black.opacity(0.001)
                                .contentShape(Rectangle())
                                .onTapGesture { nextOrClose() }
                        }
                    }
                    .ignoresSafeArea()
                }
            }
            .zIndex(1) // ниже крестика
            // Подписка на высоту HUD
            .onPreferenceChange(TopHUDMaxYKey.self) { hudMaxY = $0 }
        }
        .onAppear { startTimer() }
        .onDisappear { stopTimer() }
        // Свайп вниз — закрыть, не блокируя тапы (simultaneous)
        .simultaneousGesture(
            DragGesture(minimumDistance: 20).onEnded { v in
                if v.translation.height > 40 { stopTimer(); onClose() }
            }
        )
        .statusBarHidden(true)
    }
}

// MARK: - Логика

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
        onSeen?(index) // помечаем историю просмотренной при показе
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

// MARK: - Прогресс «в край»

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
                        Capsule().fill(Color.white)         // трек — белый
                        Capsule().fill(Color.brandBlue)     // прогресс — #3772E7
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
