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
    @ObservedObject var viewModel: WeatherViewModel
    @ObservedObject var localizationManager: LocationManager
    
    init(_ appState: AppState) {
        self._viewModel = ObservedObject(initialValue: appState.weatherViewModel)
        self._localizationManager = ObservedObject(initialValue: appState.localizationManager)
    }
    
    var body: some View {
        VStack {
            switch viewModel.status {
            case .presenting:
                weatherViewContainer
            default:
                WeatherInitialView(appState)
            }
        }
        .onAppear {
            handleLocationState()
        }
        .background(getBackgroundGradient(viewModel.weatherStatus))
        .onChange(of: localizationManager.authorizationStatus) { value in
            switch value {
            case .authorizedAlways, .authorizedWhenInUse:
                self.localizationManager.requestLocation()
            case .notDetermined:
                self.localizationManager.askForpermission()
            @unknown default:
                break
            }
        }
        .onChange(of: localizationManager.permissionDenied) { denied in
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
            if viewModel.status == .presenting {
                appState.weatherViewModel = self.viewModel
            }
        }
    }
    var weatherViewContainer: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ZStack {
                    EmptyView().id("top")
                    weatherViewComponents
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
    var weatherViewComponents: some View {
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
            if let location = localizationManager.location,
                let pin = self.localizationManager.pinLocation {
                HStack(alignment: .top) {
                    Text("\(viewModel.weather?.name ?? ""), \(viewModel.weather?.sys?.country ?? "")")
                        .multilineTextAlignment(.leading)
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    VStack {
                        Text("Today")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.trailing)
                        Text("\(viewModel.lastReportDateTime.toString())")
                            .font(.footnote)
                            .multilineTextAlignment(.trailing)
                    }
                }
                HStack {
                    VStack {
                        Image(systemName: viewModel.iconName)
                            .font(.system(size: 45))
                            .foregroundStyle(.white)
                        Text(viewModel.weather?.weather?.first?.main ?? "")
                            .font(.footnote)
                    }
                    Spacer()
                    HStack {
                        Text("\((viewModel.weather?.main?.temp ?? 0).toStringRounded)")
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
                               value: "\(viewModel.weather?.main?.humidity ?? 0) %")
                Spacer()
                WeatherDataView(icon: "figure.walk.diamond",
                               header: "mts above sea level",
                               value: "\(viewModel.weather?.main?.grnd_level ?? 0) mts")
            }
            HStack {
                WeatherDataView(icon: "thermometer.medium",
                               header: "Perceived temperature",
                               value: "\(viewModel.weather?.main?.feels_like ?? 0) °C")
                Spacer()
                WeatherDataView(icon: "wind.circle",
                               header: "Wind speed",
                                value: "\(viewModel.weather?.wind?.speed ?? 0) m/s")
                
            }
            HStack {
                WeatherDataView(icon: "sun.min",
                               header: "Min temperature",
                               value: "\(viewModel.weather?.main?.temp_min ?? 0) °C")
                Spacer()
                WeatherDataView(icon: "sun.max",
                               header: "Max temperature",
                               value: "\(viewModel.weather?.main?.temp_max ?? 0) °C")
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
                    Text("\(viewModel.weather?.coord?.lat ?? 0)")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                VStack {
                    Text("🌐 Longitude")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("\(viewModel.weather?.coord?.lon ?? 0)")
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
            self.localizationManager.requestLocation()
            withAnimation {
                if let coordinate = self.localizationManager.location?.coordinate {
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
            if let location = self.localizationManager.location,
               let pin = self.localizationManager.pinLocation {
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
    func handleLocationState() {
        switch localizationManager.authorizationStatus {
        case .notDetermined:
            viewModel.status = .askPermission
            localizationManager.askForpermission()

        case .authorizedWhenInUse, .authorizedAlways:
            if localizationManager.location == nil {
                localizationManager.requestLocation()
                viewModel.status = .loading
            } else {
                viewModel.status = .initialView // Ready to let user tap “Get Weather”
            }
        @unknown default:
            viewModel.status = .error
        }
    }
}


#Preview {
    WeatherAppView(.init())
}
