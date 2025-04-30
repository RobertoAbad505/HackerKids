//
//  WeatherAppView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/25/25.
//
import MapKit
import SwiftUI

struct WeatherAppView: View {
    @ObservedObject private var locationManager: LocationManager
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
    init(viewModel: WeatherViewModel, locationManager: LocationManager) {
        self.locationManager = locationManager
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            if !viewModel.startedFeature, !viewModel.startedFeature  {
                WeatherInitialView(locationManager: self.locationManager)
            } else if let location = locationManager.location {
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
        .onChange(of: locationManager.location) { newLocation in
            guard let coordinate = newLocation?.coordinate else {
                return
            }
            if !hasFetched {
                hasFetched = true
                withAnimation {
                    viewModel.fetchData(using: coordinate)
                }
            }
            if refreshButton {
                withAnimation {
                    viewModel.fetchData(using: coordinate)
                }
            }
        }
        .onChange(of: locationManager.permissionDenied) { denied in
            if denied {
                showErrorAlert = true
            }
        }
        .alert("Permiso de ubicación denegado", isPresented: $showErrorAlert) {
            Button("Cerrar", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Por favor activa la ubicación en configuración para usar esta funcionalidad.")
        }
        .onAppear {
            print("Fetching weather data...")
        }
        .onDisappear {
            viewModel.startedFeature = false
            hasFetched = false
            locationManager.location = nil
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
            if let location = locationManager.location, let pin = locationManager.pinLocation {
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
                               value: "\(viewModel.weather?.main?.feels_like ?? 0) m/s")
                
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
        .padding(.horizontal)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
    }
    var coordinatesView: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("📍GPS Coordinates")
                .font(.title2)
                .fontWeight(.bold)
            HStack {
                VStack {
                    Text("🌐 Latitud")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("\(viewModel.weather?.coord?.lat ?? 0)")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                Spacer()
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
            withAnimation {
                refreshButton = true
                locationManager.requestLocation()
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
            if let location = locationManager.location, let pin = locationManager.pinLocation {
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
                CodeBlockView(code: viewModel.readResponse())
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
    WeatherAppView(viewModel: .init(), locationManager: .init())
}
