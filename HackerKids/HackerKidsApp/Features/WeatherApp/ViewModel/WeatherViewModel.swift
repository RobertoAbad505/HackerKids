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
    @Published var startedFeature = false
    private var services = WeatherServices()
    var cancellables: Set<AnyCancellable> = .init()
    @Published var weather: WeatherModel?
    @Published var errorFetch: Bool = false
    @Published var iconName: String = ""
    let languageEn = "en"
    let languageEs = "es"

    func fetchData(using coordinate: CLLocationCoordinate2D) {
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        print("Llamando al API con lat: \(latitude), lon: \(longitude)")
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=0ae7859c64174984eb990d6673e70098&units=metric") else {
            print("Error generando URL del clima para lat:\(latitude), lon:\(longitude)")
            return
        }
        services.fetchWeather(url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                    self?.errorFetch = true
                case .finished:
                    self?.startedFeature = true
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
        default: return main
        }
    }
}
