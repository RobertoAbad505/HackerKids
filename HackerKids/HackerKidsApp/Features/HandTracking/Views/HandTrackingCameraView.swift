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
            HStack {
                Spacer()
                flipCameraButton
            }
            Spacer()
            gestureDisplay
            HStack {
                Spacer()
                takePictureButton
                Spacer()
            }
        }
        .foregroundStyle(Color.white.opacity(0.8))
    }
    var gestureDisplay: some View {
        HStack {
            Text(viewModel.gesture)
                .font(.largeTitle)
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.bottom, 10)
        }
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
    var takePictureButton: some View {
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
    }
}

