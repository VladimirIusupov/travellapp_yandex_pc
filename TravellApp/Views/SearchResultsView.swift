import SwiftUI

// MARK: - View
struct SearchResultsView: View {

    let fromCode: String
    let toCode: String
    let fromTitle: String
    let toTitle: String

    @Binding var path: NavigationPath
    @StateObject private var viewModel = SearchResultsViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            headerView
            contentView
            filterButton
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar { backButton }
        .toolbar(.hidden, for: .tabBar)
        .task {
            await viewModel.loadResults(from: fromCode, to: toCode)
            if let filters = viewModel.filters { viewModel.applyFilters(filters) }
        }
    }
}

// MARK: - Subviews
extension SearchResultsView {

    @ViewBuilder private var headerView: some View {
        HStack {
            Text("\(fromTitle) → \(toTitle)")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.ypBlack)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ypWhite)
    }

    @ViewBuilder private var contentView: some View {
        if viewModel.isLoading {
            Spacer()
            ProgressView("Загружаем рейсы…")
            Spacer()
                .background(Color(.ypWhite).ignoresSafeArea())
        } else if let appError = viewModel.appError {
            Spacer()
            ErrorView(type: appError.errorType)
            Spacer()
        } else if viewModel.displayedResults.isEmpty {
            Spacer()
            Text("Вариантов нет")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.ypBlackUniversal)
                .background(Color(.ypWhite).ignoresSafeArea())
            Spacer()
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.displayedResults, id: \.thread?.uid) { segment in
                        SegmentCard(viewModel: CarrierDetailsViewModel(segment: segment))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if let code = segment.thread?.carrier?.code {
                                    path.append(Route.carrierInfo(code: String(code)))
                                }
                            }
                    }
                }
                .background(Color(.ypWhite).ignoresSafeArea())
                .padding(16)
                .padding(.bottom, 100)
            }
            .background(Color(.ypWhite).ignoresSafeArea())
        }
    }

    @ViewBuilder private var filterButton: some View {
        if !viewModel.originalResults.isEmpty {
            Button {
                path.append(Route.filters)
            } label: {
                HStack(spacing: 4) {
                    Text("Уточнить время")
                        .font(.system(size: 17, weight: .bold))
                    if viewModel.filtersApplied {
                        Circle()
                            .fill(.ypRed)
                            .frame(width: 8, height: 8)
                            .padding(.leading, 8)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 60)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.ypWhiteUniversal)
            .background(.ypBlue)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            .background(Color(.ypWhite).ignoresSafeArea())
        }
    }

    private var backButton: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 17, height: 22)
                    .foregroundStyle(.primary)
            }
        }
    }
}
