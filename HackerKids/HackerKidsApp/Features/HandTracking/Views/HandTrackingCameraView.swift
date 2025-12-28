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
                Button(action: {
                    viewModel.startRPS()
                }, label: {
                    Circle()
                        .fill(.green)
                        .stroke(Color.white, lineWidth: 5)
                        .overlay {
                            Text(viewModel.rspButton)
                                .font(.system(size: 20, weight: .bold))
                                .scaleEffect(viewModel.animateScale ? 1.3 : 1.0)
                                .animation(.spring(), value: viewModel.animateScale)
                        }
                })
                .frame(maxWidth: 200, maxHeight: 200)
            } else {
                //Show marker or results view, also add reset button here
                Button(action: {
                    //Reset game
                    viewModel.isRspOn = false
                }, label: {
                    Text("Results")
                })
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
