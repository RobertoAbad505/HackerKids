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
    @State private var userLocationPin: LocationPin?
    @ObservedObject var viewModel: WeatherViewModel = .init()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )//San Francisco default region
    var daylightBackground: some View {
        LinearGradient(stops: [.init(color: .blue, location: 0.4),
                               .init(color: .white, location: 0.5),
                               .init(color: .orange, location: 0.95)
                              ],
                       startPoint: .bottomLeading,
                       endPoint: .topTrailing)
    }
    init(viewModel: WeatherViewModel, locationManager: LocationManager = .init()) {
        self.locationManager = locationManager
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            if !viewModel.startedFeature {
                WeatherInitialView(onSelect: {
                    withAnimation {
                        self.locationManager.startService()
                    }
                })
            } else if let location = locationManager.location {
                ScrollView {
                    weatherView
                }
            }
        }
        .background(daylightBackground.edgesIgnoringSafeArea(.all))
        .onChange(of: locationManager.location) { newLocation in
            if let coordinate = newLocation?.coordinate, !hasFetched {
                hasFetched = true
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
        .onDisappear {
            viewModel.startedFeature = false
        }
    }
    var weatherView: some View {
        VStack(alignment: .center, spacing: 25) {
            cityTemperature
            moreInfoView
            mapView
            Spacer()
        }
        .padding()
        .padding(.vertical)
        .foregroundStyle(.black)
    }
    var cityTemperature: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let location = locationManager.location, let pin = locationManager.pinLocation {
                HStack(alignment: .top) {
                    Text("\(viewModel.weather?.name ?? ""),\(viewModel.weather?.sys?.country ?? "")")
                        .multilineTextAlignment(.leading)
                        .font(.title)
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
                            .font(.system(size: 50))
                            .foregroundStyle(Color.white)
                        Image(systemName: "degreesign.celsius")
                            .font(.system(size: 37))
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .padding()
        .padding(.top, 20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
    }
    var moreInfoView: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Current weather")
                .font(.title)
                .fontWeight(.bold)
            HStack {
                WeatherDatView(icon: "drop.circle.fill",
                               header: "Humidity",
                               value: "\(viewModel.weather?.main?.humidity ?? 0) %")
                Spacer()
                WeatherDatView(icon: "figure.walk.diamond",
                               header: "mts above sea level",
                               value: "\(viewModel.weather?.main?.grnd_level ?? 0) mts")
            }
            HStack {
                WeatherDatView(icon: "thermometer.medium",
                               header: "Perceived temperature",
                               value: "\(viewModel.weather?.main?.feels_like ?? 0) °C")
                Spacer()
                WeatherDatView(icon: "wind.circle",
                               header: "Wind speed",
                               value: "\(viewModel.weather?.main?.feels_like ?? 0) m/s")
                
            }
            HStack {
                WeatherDatView(icon: "sun.min",
                               header: "Min temperature",
                               value: "\(viewModel.weather?.main?.temp_min ?? 0) °C")
                Spacer()
                WeatherDatView(icon: "sun.max",
                               header: "Max temperature",
                               value: "\(viewModel.weather?.main?.temp_max ?? 0) °C")
            }
            .padding(.bottom)
            navigateButton
        }
        .padding()
        .padding(.horizontal)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
    }
    var navigateButton: some View {
        Button(action: {
            refreshButton = false
            locationManager.requestLocation()
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
                    Text("Weather Map")
                        .font(.headline)
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
                Text("Map not available ...")
            }
        }
        .padding(.top, 20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
    }
    func dateToString(date: Date, dateFormat: String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = DateFormatter.dateFormat(fromTemplate: dateFormat, options: 0, locale: Locale.current)
        dateFormater.timeZone = TimeZone(secondsFromGMT: 0)
        let dateStr = dateFormater.string(from: date)
        return dateStr
    }
}
struct WeatherDatView: View {
    let icon: String
    let header: String
    let value: String

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Text(header)
                .font(.footnote)
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            HStack(alignment: .center, spacing: 5) {
                Text("\(value)")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                Image(systemName: icon)
                    .font(.system(size: 37))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
struct WeatherInitialView: View {
    let onSelect: () -> Void
    var body: some View {
        VStack(alignment: .center, spacing: 35) {
            Spacer()
            Button(action: {
                onSelect()
            }, label: {
                Image(systemName: "location.circle")
                    .font(.system(size: 110))
                    .padding(35)
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.7), radius: 10, x: -2, y: 5)
            })
            Text("Inicie la app por permitir el acceso a su ubicación.")
                .font(.title2)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .all)
        .background(Color.blue.opacity(0.8))
    }
}

#Preview {
    WeatherAppView(viewModel: .init(), locationManager: .init())
}
