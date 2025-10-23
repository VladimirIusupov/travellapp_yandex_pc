import SwiftUI

struct MainTabView: View {
    @State private var selected = 0

    var body: some View {
        TabView(selection: $selected) {
            RouteView()
                .tabItem {
                    // 11) только иконка
                    Image(systemName: "arrow.up.message.fill")
                }
                .tag(0)

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                }
                .tag(1)
        }
        .tint(.black)
    }
}
