import SwiftUI

struct MainView: View {
    @State private var fromStation: String = ""
    @State private var toStation: String = ""
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                VStack(spacing: 0) {
                    // MARK: - Stories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(0..<6) { index in
                                StoryCardView(imageName: "train\(index % 3)", title: "Text Text\nText Text")
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16) // ✅ от верхней safe area 16
                        .padding(.bottom, 44) // ✅ отступ до блока выбора станций
                    }
                    
                    // MARK: - Station Selection
                    StationSelectionView(from: $fromStation, to: $toStation)
                        .padding(.horizontal, 16) // ✅ отступы по 16 слева и справа
                    
                    Spacer()
                }
                .background(Color(.systemGray6))
                .navigationTitle("Откуда")
                .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Поездки", systemImage: "bubble.left.and.arrow.up")
            }
            .tag(0)
            
            // MARK: - Settings tab
            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gearshape.fill")
                }
                .tag(1)
        }
        .tint(.blue)
    }
}

 // MARK: - Story Card
struct StoryCardView: View {
    let imageName: String
    let title: String
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 150)
                .clipped()
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 3)
                )
                .cornerRadius(12)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
                .padding(6)
                .background(Color.black.opacity(0.4))
                .cornerRadius(6)
                .padding(6)
        }
    }
}

 // MARK: - Station Selection Block
struct StationSelectionView: View {
    @Binding var from: String
    @Binding var to: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue)
                .frame(height: 120)
            
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                    TextField("Откуда", text: $from)
                        .textFieldStyle(.plain)
                        .foregroundColor(.gray)
                    Divider().background(Color.gray)
                    TextField("Куда", text: $to)
                        .textFieldStyle(.plain)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .padding(.leading, 8)
                
                Button(action: swapStations) {
                    Image(systemName: "arrow.up.arrow.down.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                        .padding(.trailing, 8)
                }
            }
        }
    }
    
    private func swapStations() {
        (from, to) = (to, from)
    }
}

 // MARK: - Settings View
struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Настройки")
                .font(.title2)
                .padding(.top, 40)
            Spacer()
        }
    }
}

 // MARK: - Preview
#Preview {
    MainView()
}
