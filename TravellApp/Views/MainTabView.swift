import SwiftUI

struct MainTabView: View {
    @State private var selected = 0
    @Environment(\.colorScheme) private var scheme

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear

        let inactive = UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor.ypGrey : UIColor.ypGrey
        }
        appearance.stackedLayoutAppearance.normal.iconColor = inactive
        appearance.inlineLayoutAppearance.normal.iconColor  = inactive
        appearance.compactInlineLayoutAppearance.normal.iconColor = inactive

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().unselectedItemTintColor = inactive
    }

    var body: some View {
        TabView(selection: $selected) {
            RouteView()
                .tabItem {
                    Image(uiImage: tabIcon("arrow.up.message.fill"))
                }
                .tag(0)
                .labelStyle(.iconOnly)

            SettingsView()
                .tabItem {
                    Image(uiImage: tabIcon("gearshape.fill"))
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
