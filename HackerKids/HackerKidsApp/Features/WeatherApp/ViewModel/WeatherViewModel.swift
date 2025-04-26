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
    private var services = WeatherServices()
    var cancellables: Set<AnyCancellable> = .init()
    @Published var weather: WeatherModel?
    @Published var errorFetch: Bool = false
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
                    return
                }
            }, receiveValue: { [weak self] model in
                self?.processResponse(model)
            })
            .store(in: &cancellables)
    }
    func processResponse(_ response: WeatherModel) {
        self.weather = response
    }
}
