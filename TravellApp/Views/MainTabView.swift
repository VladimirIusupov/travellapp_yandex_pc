import SwiftUI

struct MainTabView: View {
    @State private var selected = 0
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        TabView(selection: $selected) {
            RouteView()
                .tabItem {
                    VStack {
                        Spacer()
                        Image(uiImage: tabIcon("arrow.up.message.fill"))
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                }
                .tag(0)
                .labelStyle(.iconOnly)

            SettingsView()
                .tabItem {
                    VStack {
                        Spacer()
                        Image(uiImage: tabIcon("gearshape.fill"))
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                }
                .tag(1)
                .labelStyle(.iconOnly)
        }
        .tint(scheme == .dark ? .white : .black)
    }

    private func tabIcon(_ systemName: String) -> UIImage {
        let cfg = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        return UIImage(systemName: systemName, withConfiguration: cfg) ?? UIImage()
    }
}
