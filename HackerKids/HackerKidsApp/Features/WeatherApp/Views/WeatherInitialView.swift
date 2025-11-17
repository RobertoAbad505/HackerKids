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
    
    init(_ vm: WeatherViewModel, _ lm: LocationManager) {
        self.viewModel = vm
        self.localizationManager = lm
    }

    var body: some View {
        VStack(alignment: .center, spacing: 35) {
            Spacer()
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
                VStack {
                    Image(systemName: "location.circle")
                        .font(.system(size: 110))
                        .padding(35)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.7), radius: 10, x: -2, y: 5)
                }
            })
            Text("Ver el clima desde su ubicación actual.")
                .font(.title2)
                .foregroundStyle(.white)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .all)
        .background(Color.blue.opacity(0.8))
    }
    
//    var startingView: some View {
//        VStack(alignment: .center, spacing: 35) {
//            
//        }
//    }
//    var reloadDataButton: some View {
//        Button(action: {
//            withAnimation {
//                if let coordinate = appState.localizationManager.location?.coordinate {
//                    self.appState.weatherViewModel.status = .initialView
//                    self.appState.weatherViewModel.fetchData(using: coordinate)
//                } else {
//                    appState.localizationManager.requestLocation()
//                }
//            }
//        }, label: {
//            HStack {
//                Image(systemName: "arrow.trianglehead.2.clockwise")
//                    .font(.system(size: 18))
//                Text("Refresh weather")
//                    .font(.footnote)
//                    .fontWeight(.bold)
//                    .fontDesign(.monospaced)
//            }
//            .padding() 
//            .padding(.horizontal)
//            .foregroundStyle(.white)
//            .background(Color.clear)
//            .overlay(
//                RoundedRectangle(cornerRadius: 12)
//                    .stroke((.white), lineWidth: 3)
//            )
//            .padding(.top)
//        })
//    }
}
