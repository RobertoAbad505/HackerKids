//
//  WeatherAppView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/25/25.
//
import MapKit
import SwiftUI

struct WeatherAppView: View {
    @EnvironmentObject var appState: AppState
    
//    @ObservedObject private var locationManager: LocationManager
    @Environment(\.dismiss) private var dismiss
    @State private var hasFetched = false
    @State private var refreshButton = false
    @State private var showErrorAlert = false
    @State private var inspectResponse = false
    @State private var scrollId = ""
    @State private var userLocationPin: LocationPin?
    @ObservedObject var viewModel: WeatherViewModel = .init()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )//San Francisco default region
    var daylightBackground: LinearGradient {
        LinearGradient(stops: [.init(color: Color(uiColor: .cyan), location: 0.70),
                               .init(color: .blue, location: 0.71),
                               .init(color: .white, location: 0.90)
                              ],
                       startPoint: .bottomLeading,
                       endPoint: .top)
    }
    var afternoonlightBackground: LinearGradient {
        LinearGradient(stops: [.init(color: .orange, location: 0.20),
                               .init(color: .yellow, location: 0.40),
                               .init(color: .pink, location: 0.60),
                               .init(color: .purple, location: 0.80),
                               .init(color: .blue.opacity(0.4), location: 0.99)
                              ],
                       startPoint: .bottomLeading,
                       endPoint: .top)
    }
    var nightlightBackground: LinearGradient {
        LinearGradient(stops: [.init(color: Color(uiColor: .magenta), location: 0.20),
                               .init(color: .purple, location: 0.40),
                               .init(color: Color(uiColor: .systemIndigo), location: 0.60),
                               .init(color: Color(hex: "0e1e43"), location: 0.80),
                               .init(color: .black, location: 0.99)
                              ],
                       startPoint: .bottom,
                       endPoint: .top)
    }
    var morningBackground: LinearGradient {
        LinearGradient(stops: [.init(color: .orange, location: 0.05),
                               .init(color: .white, location: 0.20),
                               .init(color: Color(hex: "ffcfc2"), location: 0.60),
                               .init(color: Color(uiColor: .magenta), location: 0.70),
                               .init(color: Color(uiColor: .systemIndigo), location: 0.90),
                               .init(color: .black, location: 0.99)
                              ],
                       startPoint: .bottom,
                       endPoint: .top)
    }
    func getBackgroundGradient( _ state: WeatherState) -> LinearGradient {
        switch state {
        case .nighttime:
            nightlightBackground
        case .dayTime:
            daylightBackground
        case .afternoon:
            afternoonlightBackground
        case .morning:
            morningBackground
        }
    }
    
    var body: some View {
        VStack {
            if !viewModel.startedFeature  {
                WeatherInitialView(viewModel: appState.weatherViewModel,
                                   locationManager: self.appState.localizationManager)
            } else if let location = self.appState.localizationManager.location {
                ScrollViewReader { proxy in
                    ScrollView {
                        ZStack {
                            EmptyView().id("top")
                            weatherView
                        }
                    }
                    .onChange(of: self.scrollId) { newValue in
                        if !newValue.isEmpty {
                            withAnimation {
                                proxy.scrollTo(newValue, anchor: .top)
                                self.scrollId = ""
                            }
                        }
                    }
                }
            }
        }
        .background(getBackgroundGradient(viewModel.weatherStatus))
        .onChange(of: self.appState.localizationManager.authorizationStatus) { value in
            switch value {
            case .authorizedAlways, .authorizedWhenInUse:
                self.appState.localizationManager.requestLocation()
            case .notDetermined:
                self.appState.localizationManager.askForpermission()
            @unknown default:
                break
            }
        }
        .onChange(of: self.appState.localizationManager.permissionDenied) { denied in
            if denied {
                showErrorAlert = true
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text(LocalizedStringKey("weather.alert.weather.permision.title")),
                  message: Text(LocalizedStringKey("weather.alert.weather.permision.message")),
                  primaryButton: .cancel(Text(LocalizedStringKey("close.label")), action: { dismiss()}),
                  secondaryButton: .default(Text(LocalizedStringKey("settings.go.label")), action: {
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings)
                }
            }))
        }
        .onDisappear {
            if viewModel.weather == nil {
                viewModel.startedFeature = false
                hasFetched = false
            }
            viewModel.loading = false
        }
    }
    var weatherView: some View {
        VStack(alignment: .center, spacing: 25) {
            cityTemperature
            moreInfoView
            coordinatesView
            mapView
            interactiveOptions
            Spacer(minLength: 50)
        }
        .padding()
        .padding(.vertical)
        .foregroundStyle(.black)
    }
    var cityTemperature: some View {
        VStack(alignment: .center, spacing: 20) {
            if let location = self.appState.localizationManager.location,
                let pin = self.appState.localizationManager.pinLocation {
                HStack(alignment: .top) {
                    Text("\(appState.weatherViewModel.weather?.name ?? ""), \(appState.weatherViewModel.weather?.sys?.country ?? "")")
                        .multilineTextAlignment(.leading)
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    VStack {
                        Text("Today")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.trailing)
                        Text("\(appState.weatherViewModel.lastReportDateTime.toString())")
                            .font(.footnote)
                            .multilineTextAlignment(.trailing)
                    }
                }
                HStack {
                    VStack {
                        Image(systemName: appState.weatherViewModel.iconName)
                            .font(.system(size: 45))
                            .foregroundStyle(.white)
                        Text(appState.weatherViewModel.weather?.weather?.first?.main ?? "")
                            .font(.footnote)
                    }
                    Spacer()
                    HStack {
                        Text("\((appState.weatherViewModel.weather?.main?.temp ?? 0).toStringRounded)")
                            .font(.system(size: 53))
                            .foregroundStyle(Color.white)
                            .fontWeight(.bold)
                        Image(systemName: "degreesign.celsius")
                            .font(.system(size: 37))
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .foregroundStyle(.white)
        .padding()
        .padding(.top, 20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
    }
    var moreInfoView: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Current weather")
                .font(.title2)
                .fontWeight(.bold)
            HStack {
                WeatherDataView(icon: "drop.circle.fill",
                               header: "Humidity",
                               value: "\(appState.weatherViewModel.weather?.main?.humidity ?? 0) %")
                Spacer()
                WeatherDataView(icon: "figure.walk.diamond",
                               header: "mts above sea level",
                               value: "\(appState.weatherViewModel.weather?.main?.grnd_level ?? 0) mts")
            }
            HStack {
                WeatherDataView(icon: "thermometer.medium",
                               header: "Perceived temperature",
                               value: "\(appState.weatherViewModel.weather?.main?.feels_like ?? 0) °C")
                Spacer()
                WeatherDataView(icon: "wind.circle",
                               header: "Wind speed",
                                value: "\(appState.weatherViewModel.weather?.wind?.speed ?? 0) m/s")
                
            }
            HStack {
                WeatherDataView(icon: "sun.min",
                               header: "Min temperature",
                               value: "\(viewModel.weather?.main?.temp_min ?? 0) °C")
                Spacer()
                WeatherDataView(icon: "sun.max",
                               header: "Max temperature",
                               value: "\(appState.weatherViewModel.weather?.main?.temp_max ?? 0) °C")
            }
            .padding(.bottom)
            if !refreshButton {
                reloadDataButton
            }
        }
        .foregroundStyle(.white)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
    }
    var coordinatesView: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack {
                Spacer()
                Text("📍GPS Coordinates")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            HStack {
                VStack {
                    Text("🌐 Latitud")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("\(appState.weatherViewModel.weather?.coord?.lat ?? 0)")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                VStack {
                    Text("🌐 Longitude")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("\(appState.weatherViewModel.weather?.coord?.lon ?? 0)")
                        .font(.title3)
                        .fontWeight(.bold)
                }
            }
            .padding(.horizontal, 20)
            .fontDesign(.monospaced)
        }
        .foregroundStyle(.white)
        .padding(25)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
    }
    var reloadDataButton: some View {
        Button(action: {
            self.appState.localizationManager.requestLocation()
            withAnimation {
                if let coordinate = self.appState.localizationManager.location?.coordinate {
                    refreshButton = true
                    viewModel.fetchData(using: coordinate)
                }
                scrollId = "top"
            }
        }, label: {
            HStack {
                Image(systemName: "arrow.trianglehead.2.clockwise")
                    .font(.system(size: 18))
                Text("Refresh weather")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .fontDesign(.monospaced)
            }
            .padding()
            .padding(.horizontal)
            .foregroundStyle(.white)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke((.white), lineWidth: 3)
            )
            .padding(.top)
        })
    }
    var mapView: some View {
        HStack {
            if let location = self.appState.localizationManager.location,
               let pin = self.appState.localizationManager.pinLocation {
                VStack {
                    Text("🗺️ Weather Map")
                        .font(.title2)
                        .fontWeight(.bold)
                    Map(coordinateRegion: $region, annotationItems: [pin]) { loc in
                        MapMarker(coordinate: loc.coordinate, tint: .blue)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 500)
                    .cornerRadius(5)
                    .onAppear {
                        region.center = location.coordinate
                    }
                }
            } else {
                Text("Map not available ... ⁉️ \n \t>> 🪲Bug reported!")
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
        .foregroundStyle(.white)
        .padding(.top, 20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
    }
    var interactiveOptions: some View {
        VStack {
            HStack {
                Spacer()
                Text("🕹️ Interact with this view!")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            themesView
            inspectResponseView
        }
        .foregroundStyle(.white)
        .padding(.top, 20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
    }
    var themesView: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
            ForEach(WeatherState.allCases, id: \.hashValue ) { state in
                Button(action: {
                    withAnimation {
                        viewModel.weatherStatus = state
                        self.scrollId = "top"
                    }
                }, label: {
                    VStack {
                        Circle()
                            .fill(getBackgroundGradient(state))
                            .frame(width: 50, height: 50)
                        Text(state.rawValue)
                            .font(.headline)
                    }
                })
                .foregroundStyle(.white)
                .background(.clear)
                .addRoundBorder(40, .light)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .shadow(color: Color.white.opacity(0.6), radius: 10, x: 5, y: 5)
            }
        }
    }
    var inspectResponseView: some View {
        VStack(alignment: .center, spacing: 20) {
            Button(action: {
                withAnimation {
                    inspectResponse.toggle()
                }
            }, label: {
                HStack {
                    Spacer()
                    Text(inspectResponse ? "✅ Okay!" :"🔎👀 Inspeccionar JSON response")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.white) // Color dinámico
                    Spacer()
                }
                .padding()
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke((.white), lineWidth: 3)
                )
            })
            .padding(.vertical, 20)
            .padding(.horizontal)
            if inspectResponse {
                CodeBlockView(code: viewModel.readResponse(), size: 15)
            }
        }
    }
    func dateToString(date: Date, dateFormat: String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = DateFormatter.dateFormat(fromTemplate: dateFormat, options: 0, locale: Locale.current)
        dateFormater.timeZone = TimeZone(secondsFromGMT: 0)
        let dateStr = dateFormater.string(from: date)
        return dateStr
    }

}


#Preview {
    WeatherAppView()
}
