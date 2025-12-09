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
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.exitCamera()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.white.opacity(0.9))
                            .padding()
                    }
                }
                Text(viewModel.gesture)
                    .font(.largeTitle)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.top, 50)
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                            viewModel.flipCamera.toggle()   // NEW — variable that triggers flip
                        }) {
                            Image(systemName: "camera.rotate.fill")
                                .font(.system(size: 28))
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                    Spacer()
                }
            }
        }
    }
}

