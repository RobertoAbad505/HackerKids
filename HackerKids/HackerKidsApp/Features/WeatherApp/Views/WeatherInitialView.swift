//
//  WeatherInitialView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/27/25.
//

import SwiftUI

struct WeatherInitialView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @ObservedObject var locationManager: LocationManager
    @State var refreshButton: Bool = false

    var body: some View {
        VStack(alignment: .center, spacing: 35) {
            Spacer()
            if !viewModel.errorFetch {
                startingView
            } else {
                errorView
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .all)
        .background(Color.blue.opacity(0.8))
        .onAppear {
            if locationManager.authorizationStatus == .notDetermined {
                locationManager.askForpermission()
            }
        }
    }
    var errorView : some View {
        VStack {
            Text(LocalizedStringResource("wheater.api.error.title"))
            Text("wheater.api.error.message")
            reloadDataButton
        }
    }
    var startingView: some View {
        VStack(alignment: .center, spacing: 35) {
            Button(action: {
                withAnimation {
                    self.viewModel.loading = true
                    if let coordinate = locationManager.location?.coordinate {
                        self.viewModel.fetchData(using: coordinate)
                    }
                }
            }, label: {
                Image(systemName: "location.circle")
                    .font(.system(size: 110))
                    .padding(35)
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.7), radius: 10, x: -2, y: 5)
            })
            if viewModel.loading {
                ProgressView(label: {
                    Text("Obteniendo su ubicación . . .")
                })
                .foregroundStyle(.white)
                .tint(.white)
                .font(.system(size: 14, weight: .semibold, design: .monospaced))
            } else {
                Text("Ver el clima desde su ubicación actual.")
                    .font(.title2)
                    .foregroundStyle(.white)
            }
        }
    }
    var reloadDataButton: some View {
        Button(action: {
            withAnimation {
                if let coordinate = locationManager.location?.coordinate {
                    self.viewModel.errorFetch = false
                    self.viewModel.loading = true
                    self.viewModel.startedFeature = false
                    self.viewModel.fetchData(using: coordinate)
                } else {
                    locationManager.requestLocation()
                }
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
}
