//
//  HandTrackingCameraView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 12/8/25.
//

import Foundation
import SwiftUI

struct HandTrackingCameraView: View {
    @ObservedObject var viewModel: HandTrackingViewModel
    
    var hasGesture: Bool {
        !viewModel.gesture.isEmpty && viewModel.gesture != "-"
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            CameraView(viewModel: viewModel)
                .ignoresSafeArea()
            FingerOverlayView(hands: viewModel.hands)
            buttonsOverlay
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                exitButton
            })
        }
        .toolbar(.hidden, for: .tabBar)
    }
    var buttonsOverlay: some View {
        VStack {
            flipCameraButton
            switch viewModel.trackingMode {
            case .gestures:
                trackGesturesDisplay
            case .rps:
                rpsDisplay
            }
            trackerModes
        }
        .foregroundStyle(Color.white.opacity(0.8))
    }
    var trackGesturesDisplay: some View {
        VStack {
            Spacer()
            gestureDisplay
        }
    }
    var rpsDisplay: some View {
        VStack(alignment: .center) {
            Spacer()
            if !viewModel.isRspOn {
                rpsIdleView
            } else {
                rpsResultsView
            }
            Spacer()
            gestureDisplay
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    var rpsIdleView: some View {
        Button(action: {
            viewModel.startRPS()
        }, label: {
            Circle()
                .fill(.green.opacity(0.5))
                .stroke(Color.white, lineWidth: 5)
                .overlay {
                    Text(viewModel.rspButton)
                        .font(.system(size: 20, weight: .bold))
                        .scaleEffect(viewModel.animateScale ? 1.3 : 1.0)
                        .animation(.spring(), value: viewModel.animateScale)
                }
        })
        .frame(maxWidth: 150, maxHeight: 150)
        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 10, y: 10)
    }
    var rpsResultsView: some View {
        VStack(alignment: .center, spacing: 25) {
            //Show marker or results view, also add reset button here
            Text("🏁 R E S U L T S 🏁")
                .font(Font.title3.bold())
                .monospaced()
            HStack(alignment: .center, spacing: 25) {
                VStack {
                    Text("You")
                    Text(viewModel.playerMove?.rawValue ?? "unkown")
                }
                Text("vs")
                VStack {
                    Text("App")
                    Text(viewModel.appMove?.rawValue ?? "unkown")
                }
            }
            .font(Font.title3.bold())
            .padding()
            Text(viewModel.rpsResult)
                .font(Font.title2.bold())
                .padding(.bottom, 15)
            Button(action: {
                //Reset game
                viewModel.isRspOn = false
            }, label: {
                Image(systemName: "repeat.circle")
                    .font(.system(size: 25))
                Text("Try again!")
                    .font(.body)
            })
            .padding(.horizontal, 55)
            .padding(.vertical, 10)
            .background(.green.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke((.white), lineWidth: 3)
            )
        }
        .padding(45)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke((.white), lineWidth: 3)
        )
    }
    var trackerModes: some View {
        HStack(alignment: .center, spacing: 0) {
            Picker(selection: $viewModel.trackingMode, label: Text("Tracking mode:")) {
                ForEach(HandTrackerMode.allCases, id: \.self) { gametype in
                    Text(gametype.rawValue)
                        .padding()
                }
            }
            .pickerStyle(.palette)
            .onChange(of: viewModel.trackingMode) { _ in
                print("Tracker reset...")
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .transition(.opacity)
        }
    }
    var gestureDisplay: some View {
        VStack {
            if hasGesture {
                HStack {
                    Text(viewModel.gesture)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .transition(.opacity)
            }
        }
        .padding(.horizontal)
    }
    var exitButton: some View {
        Button(action: {
            viewModel.exitCamera()
        }) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 20))
        }
    }
    var flipCameraButton: some View {
        HStack {
            Spacer()
            Button(action: {
                    viewModel.flipCamera.toggle()   // NEW — variable that triggers flip
                }) {
                    Image(systemName: "camera.rotate.fill")
                        .font(.system(size: 20))
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding(.trailing, 5)
                }
        }
    }
    var takePictureButton: some View {
        HStack {
            Spacer()
            Button(action: {
                    viewModel.flipCamera.toggle()   // NEW — variable that triggers flip
                }) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 20))
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding(.vertical, 25)
                }
            Spacer()
        }
    }
}

#Preview {
    HandTrackingCameraView(viewModel: .init())
}
