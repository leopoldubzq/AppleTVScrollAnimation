import SwiftUI

struct ImageScrollAnimationView: View {
    
    // MARK: - State
    
    @State private var tvSeriesPosters: [MoviePoster] = MoviePoster.mock
    @State private var topChartMovies: [MoviePoster] = MoviePoster.mockMovies
    @State private var scrollOffset: CGFloat = .zero
    @State private var visibleHorizontalIndex: Int = 0
    @State private var scrollPosition = ScrollPosition(x: .zero)
    @State private var pageIndicatorProgress: CGFloat = 0.2
    @State private var isScrolling: Bool = false
    
    // MARK: - Environment
    
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Constants
    
    private let pageIndicatorProgressInitialValue: CGFloat = 0.2
    private let timer = Timer.publish(
        every: 0.01,
        on: .main,
        in: .common
    ).autoconnect()
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            let fullHeight = size.height + safeArea.top + safeArea.bottom
            ScrollView {
                VStack {
                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            ForEach(tvSeriesPosters, id: \.id) { poster in
                                PosterImage(imageName: poster.name)
                                    .frame(width: size.width)
                                    .onScrollVisibilityChange { isVisible in
                                        if isVisible {
                                            guard let visibleIndex = tvSeriesPosters.firstIndex(of: poster) else {
                                                return
                                            }
                                            self.visibleHorizontalIndex = visibleIndex
                                        }
                                    }
                                    .scrollTransition { content, phase in
                                        content
                                            .opacity(phase.isIdentity ? 1 : 0.85)
                                            .blur(radius: phase.isIdentity ? 0 : 2)
                                    }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.paging)
                    .scrollClipDisabled()
                    .scrollPosition($scrollPosition)
                    .onScrollPhaseChange { _, phase in
                        isScrolling = phase.isScrolling
                    }
                    .frame(height: fullHeight * 0.7)
                    .overlay(alignment: .bottom) {
                        HStack {
                            ForEach(tvSeriesPosters.indices, id: \.self) { index in
                                Capsule()
                                    .fill(
                                        colorScheme == .dark ? .secondary : Color.init(uiColor: .lightGray)
                                    )
                                    .frame(
                                        width: visibleHorizontalIndex == index ? 20 : 6,
                                        height: 6
                                    )
                                    .overlay(alignment: .leading) {
                                        if visibleHorizontalIndex == index {
                                            Capsule()
                                                .fill(.white)
                                                .frame(width: 20 * pageIndicatorProgress)
                                                .transition(.blurReplace)
                                        }
                                    }
                                    .animation(.smooth(duration: 0.3),
                                               value: visibleHorizontalIndex)
                            }
                        }
                        .padding(8)
                        .padding(.bottom, 8)
                        .scaleEffect(1.2)
                    }
                    
                    topChartMoviesSection
                }
                .padding(.bottom)
            }
            .scrollIndicators(.hidden)
            .animation(.smooth(duration: 0.35), value: scrollPosition)
            .onScrollGeometryChange(for: CGFloat.self, of: { geometry in
                geometry.contentOffset.y + geometry.contentInsets.top
            },
                                    action: { _, newValue in
                scrollOffset = newValue
            })
            .ignoresSafeArea()
            .onChange(of: pageIndicatorProgress) { _, newValue in
                if newValue >= 1 {
                    if visibleHorizontalIndex == tvSeriesPosters.count - 1 {
                        scrollPosition.scrollTo(edge: .leading)
                    } else {
                        scrollToNextCell(size: size)
                    }
                    pageIndicatorProgress = pageIndicatorProgressInitialValue
                }
            }
        }
        .onReceive(timer) { _ in
            guard isScrolling == false else {
                return
            }
            let incrementValue = calculateIncrement(
                duration: 5.0,
                updateInterval: 0.01
            )
            pageIndicatorProgress += incrementValue
        }
        .onChange(of: visibleHorizontalIndex) { _, _ in
            pageIndicatorProgress = pageIndicatorProgressInitialValue
        }
    }
    
    // MARK: - Views
    
    @ViewBuilder
    private func PosterImage(imageName: String) -> some View {
        GeometryReader { proxy in
            let minX = proxy.frame(in: .scrollView).minX
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(x: -minX * 0.6)
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.height + max(0, -scrollOffset)
                )
                .clipped()
                .contentShape(.rect)
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(
                            .linearGradient(colors: [
                                Color(uiColor: .black).opacity(0.7),
                                Color(uiColor: .black).opacity(0.6),
                                Color(uiColor: .black).opacity(0.5),
                                Color(uiColor: .black).opacity(0.2),
                                Color(uiColor: .black).opacity(0.1),
                                Color(uiColor: .black).opacity(0.05),
                                Color(uiColor: .black).opacity(0.01)
                            ], startPoint: .top, endPoint: .center)
                        )
                }
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(
                            .linearGradient(colors: [
                                Color(uiColor: .black).opacity(0.85),
                                Color(uiColor: .black).opacity(0.7),
                                Color(uiColor: .black).opacity(0.6),
                                Color(uiColor: .black).opacity(0.5),
                                Color(uiColor: .black).opacity(0.2),
                                Color(uiColor: .black).opacity(0.1),
                                Color(uiColor: .black).opacity(0.05),
                                Color(uiColor: .black).opacity(0.01)
                            ], startPoint: .bottom, endPoint: .center)
                        )
                }
                .offset(y: min(0, scrollOffset))
        }
    }
    
    private var topChartMoviesSection: some View {
        VStack {
            topChartMoviesSectionTitle
            topChartMoviesSectionContent
        }
        .padding()
        .padding(.bottom, 50)
    }
    
    private var topChartMoviesSectionTitle: some View {
        HStack {
            Text("Top Chart: Movies")
                .foregroundStyle(.primary)
                .font(.title2)
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
            Spacer()
        }
        .fontWeight(.bold)
    }
    
    private var topChartMoviesSectionContent: some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(topChartMovies, id: \.id) { movie in
                        VStack(alignment: .leading) {
                            Image(movie.name)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(
                                    width: size.width * 0.45,
                                    height: size.height
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            HStack {
                                if let index = topChartMovies.firstIndex(of: movie) {
                                    Text("\(index + 1)")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.secondary)
                                }
                                VStack(alignment: .leading) {
                                    Text(movie.title)
                                    HStack(spacing: 4) {
                                        let year = "\(movie.year)".replacingOccurrences(of: " ", with: "")
                                        Text(year)
                                        Text("•")
                                        Text(movie.category)
                                    }
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                }
                                .lineLimit(1)
                            }
                        }
                        .frame(maxWidth: size.width * 0.45)
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1.0 : 0.7)
                                .blur(radius: phase.isIdentity ? 0 : 2)
                                .scaleEffect(phase.isIdentity ? 1 : 0.96)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .scrollClipDisabled()
        }
        .frame(height: 100)
    }
    
    private func calculateIncrement(duration: TimeInterval,
                                    updateInterval: TimeInterval) -> Double {
        (1.0 - pageIndicatorProgressInitialValue) / (duration / updateInterval)
    }
    
    private func scrollToNextCell(size: CGSize) {
        let xPosition = size.width * CGFloat(visibleHorizontalIndex + 1)
        scrollPosition.scrollTo(x: xPosition)
    }
}

#Preview {
    ImageScrollAnimationView()
}

