import SwiftUI
import Foundation

// MARK: - Service Wrapper
class YandexRaspServiceManager: ObservableObject {
    private let apiKey: String
    private let baseURL = "https://api.rasp.yandex.net/v3.0"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // MARK: - API Methods
    func getSchedule(from: String = "s2000006", to: String = "s9600213") async {
        await makeAPIRequest(
            endpoint: "/search/",
            parameters: ["from": from, "to": to],
            methodName: "getSchedule"
        )
    }
    
    func getStationSchedule(station: String = "s2000006") async {
        await makeAPIRequest(
            endpoint: "/schedule/",
            parameters: ["station": station],
            methodName: "getStationSchedule"
        )
    }
    
    func getThread(uid: String = "6310_0_9601006_g25_4") async {
        await makeAPIRequest(
            endpoint: "/thread/",
            parameters: ["uid": uid],
            methodName: "getThread"
        )
    }
    
    func getNearestStations(lat: Double = 55.7558, lng: Double = 37.6173, distance: Int = 50) async {
        await makeAPIRequest(
            endpoint: "/nearest_stations/",
            parameters: [
                "lat": "\(lat)",
                "lng": "\(lng)",
                "distance": "\(distance)"
            ],
            methodName: "getNearestStations"
        )
    }
    
    func getNearestSettlement(lat: Double = 55.7558, lng: Double = 37.6173, distance: Int = 10) async {
        await makeAPIRequest(
            endpoint: "/nearest_settlement/",
            parameters: [
                "lat": "\(lat)",
                "lng": "\(lng)",
                "distance": "\(distance)"
            ],
            methodName: "getNearestSettlement"
        )
    }
    
    func getStationsList() async {
        await makeAPIRequest(
            endpoint: "/stations_list/",
            parameters: [:],
            methodName: "getStationsList"
        )
    }
    
    func getCarrier(code: String = "153") async {
        await makeAPIRequest(
            endpoint: "/carrier/",
            parameters: ["code": code],
            methodName: "getCarrier"
        )
    }
    
    func getCopyright() async {
        await makeAPIRequest(
            endpoint: "/copyright/",
            parameters: [:],
            methodName: "getCopyright"
        )
    }
    
    // MARK: - Generic API Request Method
    private func makeAPIRequest(endpoint: String, parameters: [String: String], methodName: String) async {
        print("🚀 === \(methodName) ===")
        
        var urlComponents = URLComponents(string: "\(baseURL)\(endpoint)")!
        var queryItems = [URLQueryItem(name: "apikey", value: apiKey), URLQueryItem(name: "format", value: "json")]
        
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            print("❌ Invalid URL")
            return
        }
        
        print("📡 URL: \(url)")
        print("⚙️ Parameters: \(parameters)")
        
        do {
            var request = URLRequest(url: url)
            request.timeoutInterval = 30
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response")
                return
            }
            
            print("📊 Status Code: \(httpResponse.statusCode)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                if httpResponse.statusCode == 200 {
                    print("✅ RAW JSON Response:")
                    print(responseString)
                    print("✅ === End of \(methodName) response ===")
                } else {
                    print("❌ Error Response (\(httpResponse.statusCode)):")
                    print(responseString)
                    print("❌ === End of \(methodName) error ===")
                }
            } else {
                print("❌ Cannot decode response as UTF-8")
            }
            
        } catch {
            print("💥 Network Error: \(error.localizedDescription)")
        }
        
        print("") // Empty line for better readability
    }
}
// MARK: - Main View
struct MainView: View {
    @StateObject private var serviceManager = YandexRaspServiceManager(
        apiKey: "1f2c5032-21fe-4e2f-9551-194476034e64"
    )
    
    var body: some View {
        NavigationView {
            List {
                apiButton(
                    title: "Расписание между станциями",
                    icon: "clock",
                    action: { await serviceManager.getSchedule() }
                )
                
                apiButton(
                    title: "Расписание на станции",
                    icon: "building.2",
                    action: { await serviceManager.getStationSchedule() }
                )
                
                apiButton(
                    title: "Станции маршрута",
                    icon: "map",
                    action: { await serviceManager.getThread() }
                )
                
                apiButton(
                    title: "Ближайшая станция",
                    icon: "location",
                    action: { await serviceManager.getNearestStations() }
                )
                
                apiButton(
                    title: "Ближайший населенный пункт",
                    icon: "mappin.and.ellipse",
                    action: { await serviceManager.getNearestSettlement() }
                )
                
                apiButton(
                    title: "Информация о перевозчике",
                    icon: "person.2",
                    action: { await serviceManager.getCarrier() }
                )
                
                apiButton(
                    title: "Список станций",
                    icon: "list.bullet",
                    action: { await serviceManager.getStationsList() }
                )
                
                apiButton(
                    title: "Копирайт",
                    icon: "c.circle",
                    action: { await serviceManager.getCopyright() }
                )
            }
            .navigationTitle("Яндекс.Транспорт")
        }
    }
    
    private func apiButton(title: String, icon: String, action: @escaping () async -> Void) -> some View {
        Button(action: {
            Task {
                await action()
            }
        }) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 30)
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
}
