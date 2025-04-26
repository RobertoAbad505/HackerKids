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
    @State private var showErrorAlert = false
    @ObservedObject var viewModel: WeatherViewModel = .init()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )//San Francisco default region
    var daylightBackground: some View {
        LinearGradient(stops: [.init(color: .blue, location: 0.4),
                               .init(color: .white, location: 0.5),
                               .init(color: .orange, location: 0.6),
                               .init(color: .blue, location: 0.8),
                               .init(color: .white, location: 0.9)
                              ],
                       startPoint: .center,
                       endPoint: .center)
    }
    init(viewModel: WeatherViewModel, locationManager: LocationManager = .init()) {
        self.locationManager = locationManager
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                ScrollView {
                    weatherView
                }
            } else {
                ProgressView("Obteniendo ubicación…")
            }
        }
        .background(daylightBackground.edgesIgnoringSafeArea(.all))
//        .background(daylightBackground.edgesIgnoringSafeArea(.all))
        .onChange(of: locationManager.location) { newLocation in
            if let coordinate = newLocation?.coordinate, !hasFetched {
                hasFetched = true
                viewModel.fetchData(using: coordinate)
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
    }
    var weatherView: some View {
        VStack {
            Button(action: {
                locationManager.requestLocation()
            }, label: {
                Text("🔄")
                    .font(.system(.body, design: .monospaced, weight: .bold))
            })
            if let location = locationManager.location, let pin = locationManager.pinLocation {
                Text("coordenadas lat:\(location.coordinate.latitude), long:\(location.coordinate.longitude)")
                Text("Ubicacion: \(viewModel.weather?.name ?? "")")
                Text("Temperatura: \((viewModel.weather?.main?.temp ?? 0).toStringRounded) °C")
                Spacer()
                Map(coordinateRegion: $region, annotationItems: [pin]) { loc in
                    MapMarker(coordinate: loc.coordinate, tint: .blue)
                }
                .frame(height: 300)
                .cornerRadius(15)
                .onAppear {
                    region.center = location.coordinate
                }
            }
        }
        .foregroundStyle(.black)
    }
}

#Preview {
    WeatherAppView(viewModel: .init())
}
