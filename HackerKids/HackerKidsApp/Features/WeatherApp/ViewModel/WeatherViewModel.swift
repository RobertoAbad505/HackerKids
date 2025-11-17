//
//  WeatherViewModel.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/25/25.
//
import Combine
import CoreLocation
import Foundation

class WeatherViewModel: ObservableObject {
    @Published var lastReportDateTime: Date = .now
    private var services = WeatherServices()
    @Published var weather: WeatherModel?
    @Published var iconName: String = ""
    @Published var weatherStatus: WeatherState = .dayTime
    @Published var status: WeatherStep = .initialView
    var cancellables: Set<AnyCancellable> = .init()
    let languageEn = "en"
    let languageEs = "es"
    
    init() {
        setCurrentDayTime()
    }

    func fetchData(using coordinate: CLLocationCoordinate2D) {
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        print("🪲 Llamando al API con lat: \(latitude), lon: \(longitude)")
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=0ae7859c64174984eb990d6673e70098&units=metric") else {
            print("Error generando URL del clima para lat:\(latitude), lon:\(longitude)")
            self.status = .error
            return
        }
        self.status = .loading
        services.fetchWeather(url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("❌❌❌Error: \(error.errorDescription)")
                    self?.status = .error
                case .finished:
                    return
                }
            }, receiveValue: { [weak self] model in
                self?.processResponse(model)
            })
            .store(in: &cancellables)
    }
    func processResponse(_ response: WeatherModel) {
        self.weather = response
        if let intTime = response.dt {
            self.lastReportDateTime = Date(timeIntervalSince1970: TimeInterval(intTime))
        }
        self.iconName = getIconName()
        self.status = .presenting
        print("🌤️ Weather processed: status is presenting!")
    }
    func getIconName() -> String {
        guard let main = weather?.weather?.first?.main else {
            return ""
        }
        switch main.lowercased() {
        case "clouds": return "cloud.fill"
        case "clear": return "sun.max.fill"
        case "rain": return "cloud.rain.fill"
        case "wind": return "wind.circle.fill"
        case "sunny": return "wind.circle.fill"
        case "rainy": return "cloud.rain.fill"
        case "storm": return "cloud.bolt.rain"
        default: return "sun.max.fill"
        }
    }
    func setCurrentDayTime() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<9 :
            self.weatherStatus = .morning
        case 9..<16 :
            self.weatherStatus = .dayTime
        case 16..<17 :
            self.weatherStatus = .afternoon
        case 17..<22 :
            self.weatherStatus = .nighttime
        default: self.weatherStatus = .dayTime
        }
    }
    func readResponse() -> String {
        guard let content = weather else {
            return ""
        }
        return content.toJSON()
    }
    func restore(_ vm: WeatherViewModel) {
        self.weather = vm.weather
        self.lastReportDateTime = vm.lastReportDateTime
        self.iconName = vm.iconName
        self.status = vm.status
    }
    func reset() {
        self.weather = nil
        self.lastReportDateTime = .now
        self.iconName = ""
        self.status = .loading
    }
}
enum WeatherState: String, CaseIterable {
    case nighttime = "Night time"
    case dayTime = "Day time"
    case afternoon = "Afternoon"
    case morning = "Morning"
}
enum WeatherStep {
    case askPermission
    case initialView
    case loading
    case presenting
    case missingLocation
    case error
}
