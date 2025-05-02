//
//  WeatherInitialView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/27/25.
//

import SwiftUI

struct WeatherInitialView: View {
    @ObservedObject var locationManager: LocationManager
    @State var loading: Bool = false

    var body: some View {
        VStack(alignment: .center, spacing: 35) {
            Spacer()
            Button(action: {
                self.locationManager.requestLocation()
                withAnimation {
                    self.loading = true
                }
            }, label: {
                Image(systemName: "location.circle")
                    .font(.system(size: 110))
                    .padding(35)
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.7), radius: 10, x: -2, y: 5)
            })
            if loading {
                ProgressView(label: {
                    Text("Obteniendo su ubicación . . .")
                })
                .foregroundStyle(.white)
                .tint(.white)
                .font(.system(size: 14, weight: .semibold, design: .monospaced))
            } else if locationManager.authorizationStatus == .notDetermined {
                Text("Inicie la app para permitir el acceso a su ubicación.")
                    .font(.title2)
                    .foregroundStyle(.white)
            } else {
                Text("Ver el clima desde su ubicación actual.")
                    .font(.title2)
                    .foregroundStyle(.white)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .all)
        .background(Color.blue.opacity(0.8))
    }
}
