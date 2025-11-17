//
//  WeatherInitialView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/27/25.
//

import SwiftUI

struct WeatherInitialView: View {
    @EnvironmentObject var appState: AppState
    @State var refreshButton: Bool = false
    @ObservedObject var viewModel: WeatherViewModel
    @ObservedObject var localizationManager: LocationManager
    
    init(_ appState: AppState) {
        self._viewModel = ObservedObject(initialValue: appState.weatherViewModel)
        self._localizationManager = ObservedObject(initialValue: appState.localizationManager)
    }

    var body: some View {
        VStack(alignment: .center, spacing: 35) {
            Spacer()
            switch appState.weatherViewModel.status {
            case .initialView, .askPermission, .missingLocation:
                startingView
            case .loading:
                loadingView
            case .presenting:
                startingView
            case .error:
                errorView
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .all)
        .background(Color.blue.opacity(0.8))
    }
    
    var startingView: some View {
        VStack(alignment: .center, spacing: 35) {
            Button(action: {
                withAnimation {
                    if localizationManager.isLocationAvailable,
                       let coordinate = appState.localizationManager.location?.coordinate {
                        viewModel.fetchData(using: coordinate)
                    } else {
                        print("❌❌❌❌Error: GPS location is missing...")
                        viewModel.status = .error
                    }
                }
            }, label: {
                locationButtonView
            })
            Text("Ver el clima desde su ubicación actual.")
                .font(.title2)
                .foregroundStyle(.white)
        }
    }
    var errorView : some View {
        VStack {
            Text(LocalizedStringResource("wheater.api.error.title"))
            Text("wheater.api.error.message")
//            reloadDataButton
        }
    }
    var locationButtonView: some View {
        VStack {
            Image(systemName: "location.circle")
                .font(.system(size: 110))
                .padding(35)
                .background(.white)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.7), radius: 10, x: -2, y: 5)
        }
    }
    var loadingView: some View {
        VStack {
            locationButtonView
            ProgressView(label: {
                Text("Obteniendo su ubicación . . .")
            })
            .foregroundStyle(.white)
            .tint(.white)
            .font(.system(size: 14, weight: .semibold, design: .monospaced))
        }
    }
    var reloadDataButton: some View {
        Button(action: {
            withAnimation {
                if let coordinate = appState.localizationManager.location?.coordinate {
                    self.appState.weatherViewModel.status = .initialView
                    self.appState.weatherViewModel.fetchData(using: coordinate)
                } else {
                    appState.localizationManager.requestLocation()
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
