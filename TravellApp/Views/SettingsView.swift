import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    // ✅ Удобный init по умолчанию
    init(viewModel: SettingsViewModel = SettingsViewModel()) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: $viewModel.isDarkTheme) {
                        Text("Тёмная тема")
                    }
                }
                Section {
                    NavigationLink {
                        LegalView()
                    } label: {
                        HStack {
                            Text("Пользовательское соглашение")
                            Spacer()
                                .font(.footnote)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Настройки")
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 4) {
                    Text("Приложение использует API «Яндекс.Расписания»")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
    }
}
