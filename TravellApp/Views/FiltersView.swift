import SwiftUI

struct FiltersView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = FiltersViewModel()

    let onApply: (Filters) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // Навбар (кастом)
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 17, height: 22)
                            .foregroundStyle(.ypBlack)
                    }
                    .padding(.leading, 8)
                    .padding(.vertical, 11)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)

                // Блок 1
                Text("Время отправления")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 27)

                VStack(alignment: .leading, spacing: 38) {
                    TimeRowView(title: "Утро 06:00 – 12:00", isOn: $viewModel.morning)
                    TimeRowView(title: "День 12:00 – 18:00",  isOn: $viewModel.day)
                    TimeRowView(title: "Вечер 18:00 – 00:00", isOn: $viewModel.evening)
                    TimeRowView(title: "Ночь 00:00 – 06:00",  isOn: $viewModel.night)
                }
                .padding(.horizontal, 16)
                .padding(.top, 35)

                // Блок 2
                Text("Показывать варианты с пересадками")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 35)

                VStack(alignment: .leading, spacing: 38) {
                    TransferRowView(title: "Да",
                                    isSelected: viewModel.transfers == true,
                                    onTap: { viewModel.selectTransfer(true) })

                    TransferRowView(title: "Нет",
                                    isSelected: viewModel.transfers == false,
                                    onTap: { viewModel.selectTransfer(false) })
                }
                .padding(.horizontal, 16)
                .padding(.top, 35)
                Spacer(minLength: 120)
            }
        }
        .background(Color(.ypWhite).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)

        .safeAreaInset(edge: .bottom) {
            Button {
                if let filters = viewModel.buildFilters() {
                    onApply(filters)
                    dismiss()
                }
            } label: {
                Text("Применить")
                    .font(.system(size: 17, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .foregroundStyle(.white)
                    .background(
                        viewModel.isApplyEnabled
                        ? Color.ypBlue
                        : Color.ypBlue.opacity(0.35)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.plain)
            .disabled(!viewModel.isApplyEnabled)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 24)
            .background(
                Color(.ypWhite).opacity(0.97).ignoresSafeArea(edges: .bottom)
            )
        }
    }
}

#if DEBUG
import SwiftUI

#Preview("Filters – light") {
    NavigationStack {
        FiltersView(onApply: { _ in })
    }
}

#Preview("Filters – dark") {
    NavigationStack {
        FiltersView(onApply: { _ in })
            .preferredColorScheme(.dark)
    }
}
#endif

