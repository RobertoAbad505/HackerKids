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
    }
    var buttonsOverlay: some View {
        VStack {
            flipCameraButton
            Spacer()
            gestureDisplay
            takePictureButton
        }
        .foregroundStyle(Color.white.opacity(0.8))
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

