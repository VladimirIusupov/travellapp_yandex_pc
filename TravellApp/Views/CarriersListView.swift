import SwiftUI

struct CarriersListView: View {
    @ObservedObject var viewModel: CarriersListViewModel
    let onOpenFilters: () -> Void
    let onOpenDetails: (CarrierItem) -> Void

    var body: some View {
        ZStack {
            if viewModel.filtered.isEmpty {
                VStack {
                    Spacer(minLength: 120)
                    Text("Вариантов нет")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            } else {
                List {
                    Section {
                        ForEach(viewModel.filtered) { item in
                            Button { onOpenDetails(item) } label: { CarrierRow(item: item) }
                                .buttonStyle(.plain)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("\(viewModel.titleFrom) → \(viewModel.titleTo)")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button {
                onOpenFilters()
            } label: {
                Text("Уточнить время")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
    }
}

private struct CarrierRow: View {
    let item: CarrierItem
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6))
                Image(systemName: item.logoSystemName).imageScale(.large)
            }
            .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(item.name).font(.subheadline).bold()
                    if let sub = item.subtitle { Text(sub).font(.caption).foregroundStyle(.blue) }
                    Spacer()
                    Text("16 января").font(.caption2).foregroundStyle(.secondary)
                }
                HStack {
                    Text(item.depTime).font(.body)
                    Spacer()
                    Text(item.duration).font(.caption).foregroundStyle(.secondary)
                    Spacer()
                    Text(item.arrTime).font(.body)
                }
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)))
    }
}
