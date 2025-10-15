import SwiftUI

struct CarriersListView: View {
    @ObservedObject var viewModel: CarriersListViewModel
    let onOpenFilters: () -> Void
    let onOpenDetails: (CarrierItem) -> Void

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Заголовок маршрута — 24 pt
                    Text(titleText)
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                    if viewModel.filtered.isEmpty {
                        Text("Вариантов нет")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 60)
                            .padding(.horizontal, 20)
                    } else {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.filtered) { item in
                                CarrierCard(item: item) {
                                    onOpenDetails(item)
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }

                    Spacer(minLength: 120)
                }
            }

            if !viewModel.didLoadOnce && viewModel.filtered.isEmpty {
                ProgressView().scaleEffect(1.15)
            }
        }
        .task { await viewModel.ensureLoaded() }
        .safeAreaInset(edge: .bottom) {
            Button(action: onOpenFilters) {
                Text("Уточнить время")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
            }
            .buttonStyle(.borderedProminent)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .shadow(color: Color.black.opacity(0.12), radius: 12, y: 6)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var titleText: String {
        let from = viewModel.titleFrom.isEmpty ? "Откуда" : viewModel.titleFrom
        let to   = viewModel.titleTo.isEmpty   ? "Куда"   : viewModel.titleTo
        return "\(from) → \(to)"
    }
}

// MARK: - Карточка

private struct CarrierCard: View {
    let item: CarrierItem
    let onTap: () -> Void

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                // Верхний ряд
                HStack(alignment: .center, spacing: 12) {
                    logo

                    // Текстовый блок фиксированной высоты, чтобы центрироваться по логотипу
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name)
                            .font(.system(size: 17, weight: .regular)) // Regular 17
                            .foregroundStyle(.primary)

                        if let subtitle = item.subtitle, !subtitle.isEmpty {
                            Text(subtitle)
                                .font(.system(size: 13, weight: .regular))
                                .foregroundStyle(Color.red)
                        }
                    }
                    .frame(height: 56, alignment: item.subtitle?.isEmpty == false ? .top : .center) // центр, если подзаголовка нет

                    Spacer(minLength: 8)

                    if let date = itemDateRight {
                        Text(date)
                            .font(.system(size: 12, weight: .regular)) // Regular 12
                            .foregroundStyle(.secondary)
                    }
                }

                // Таймлайн: Regular 17 / 12
                timeline(dep: item.depTime, duration: item.duration, arr: item.arrTime)
            }
            .padding(16)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous)) // ← 24
            .shadow(color: (scheme == .light ? .black.opacity(0.08) : .black.opacity(0.55)),
                    radius: (scheme == .light ? 6 : 10), y: 2)
        }
        .buttonStyle(.plain)
    }

    private var logo: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.systemGray6))
                .frame(width: 56, height: 56)
            Image(systemName: item.logoSystemName)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .foregroundStyle(.red)
        }
        .accessibilityHidden(true)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(Color(uiColor: .secondarySystemBackground))
    }

    // Подключишь поле даты — верни его здесь
    private var itemDateRight: String? {
        nil
    }

    private func timeline(dep: String, duration: String, arr: String) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Text(dep)
                .font(.system(size: 17, weight: .regular))  // Regular 17
                .foregroundStyle(.primary)
                .fixedSize()

            line

            Text(duration)
                .font(.system(size: 12, weight: .regular))  // Regular 12
                .foregroundStyle(.secondary)
                .fixedSize()

            line

            Text(arr)
                .font(.system(size: 17, weight: .regular))  // Regular 17
                .foregroundStyle(.primary)
                .fixedSize()
        }
    }

    private var line: some View {
        Rectangle()
            .fill(Color.secondary.opacity(0.35))
            .frame(height: 1)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
    }
}
