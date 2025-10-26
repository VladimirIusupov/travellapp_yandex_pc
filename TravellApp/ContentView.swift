import SwiftUI
import OpenAPIURLSession

struct ContentView: View {
    var body: some View {
        VStack {
        }
        .padding()
        .onAppear {
            testFetchStations()
            testFetchSchedule()
            testFetchStationSchedule()
            testFetchRouteStations()
            testFetchNearestCity()
            testFetchCarrier()
            testFetchAllStations()
            testFetchCopyrightInfo()
            testFetchMoscowToPetersburg()
        }
    }
    
    func testFetchStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                let service = NearestStationsService(
                    client: client,
                    apikey: Config.yandexAPIKey
                )
                
                print("Fetching stations...")
                let stations = try await service.getNearestStations(
                    lat: 59.864177,
                    lng: 30.319163,
                    distance: 50
                )
                
                print("Successfully fetched stations: \(stations)")
            } catch {
                print("Error fetching stations: \(error)")
            }
        }
    }
    
    func testFetchSchedule() {
        Task {
            do {
                
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = SearchService(
                    client: client,
                    apikey: Config.yandexAPIKey
                )
                
                print("Fetching schedule...")
                let schedule = try await service.getSchedule(
                    from: "c213",
                    to: "c54"
                )
                
                print("Successfully fetched schedule: \(schedule)")
                
            } catch {
                
                print("Error fetching schedule: \(error)")
            }
        }
    }
    
    func testFetchStationSchedule() {
        Task {
            do {
                
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = StationScheduleService(
                    client: client,
                    apikey: Config.yandexAPIKey
                )
                
                print("Fetching station schedule...")
                let schedule = try await service.getStationSchedule(
                    station: "s9602497"
                )
                
                print("Successfully fetched station schedule: \(schedule)")
            } catch {
                
                print("Error fetching station schedule: \(error)")
            }
        }
    }
    
    func testFetchRouteStations() {
        Task {
            do {
                
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let serviceStation = StationScheduleService(
                    client: client,
                    apikey: Config.yandexAPIKey
                )
                
                let service = RouteStationsService(
                    client: client,
                    apikey: Config.yandexAPIKey,
                    stationScheduleService: serviceStation
                )
                
                print("Fetching route stations...")
                let routeStations = try await service.getRouteStations(
                    stationCode: "s9602497"
                )
                
                print("Successfully fetched thread stations: \(routeStations)")
            } catch {
                
                print("Error fetching thread stations: \(error)")
            }
        }
    }
    
    func testFetchNearestCity() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = NearestCityService(
                    client: client,
                    apikey: Config.yandexAPIKey
                )
                
                print("Fetching nearest city...")
                let city = try await service.getNearestCity(
                    lat: 59.864177,
                    lng: 30.319163
                )
                
                print("Successfully fetched nearest city: \(city)")
            } catch {
                print("Error fetching nearest city: \(error)")
            }
        }
    }
    
    func testFetchCarrier() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = CarrierInfoService(
                    client: client,
                    apikey: Config.yandexAPIKey
                )
                
                print("Fetching carrier info...")
                let carrier = try await service.getCarrierInfo(code: "680")
                
                print("Successfully fetched carrier info: \(carrier)")
            } catch {
                print("Error fetching carrier info: \(error)")
            }
        }
    }
    
    func testFetchAllStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = AllStationsService(
                    client: client,
                    apikey: Config.yandexAPIKey
                )
                
                print("Fetching all stations...")
                let allstations = try await service.getAllStations()
                
                print("Successfully fetched all stations: \(allstations)")
            } catch {
                print("Error fetching all stations: \(error)")
            }
        }
    }
    
    func testFetchCopyrightInfo() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = CopyrightService(
                    client: client,
                    apikey: Config.yandexAPIKey
                )
                
                print("Fetching copyright info...")
                let copyright = try await service.getCopyright()
                
                print("Successfully fetched copyright info: \(copyright)")
            } catch {
                print("Error fetching copyright info: \(error)")
            }
        }
    }
    func testFetchMoscowToPetersburg() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = SearchService(
                    client: client,
                    apikey: Config.yandexAPIKey
                )
                
                print("Fetching schedule Moscow → SPB...")
                
                let schedule = try await service.getSchedule(
                    from: "s2000003",
                    to: "s9602496"
                )
                
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                
                print(" Successfully fetched schedule:")
                for seg in schedule.segments ?? [] {
                    let dep = seg.departure.map { formatter.string(from: $0) } ?? "?"
                    let arr = seg.arrival.map { formatter.string(from: $0) } ?? "?"
                    print(" \(seg.thread?.title ?? "?") \(dep) → \(arr)")
                }
            } catch {
                print(" Error fetching schedule: \(error)")
            }
        }
    }
}
