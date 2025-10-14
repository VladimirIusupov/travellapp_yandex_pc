import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            RouteView()                  
                .tabItem {
                    Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
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
