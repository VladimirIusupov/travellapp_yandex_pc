import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            RouteView()
                .tabItem {
                    Image(systemName: "arrow.up.message.fill") // ← новая иконка
                    Text("Маршрут")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Настройки")
                }
        }
    }
}

#Preview { MainTabView() }
