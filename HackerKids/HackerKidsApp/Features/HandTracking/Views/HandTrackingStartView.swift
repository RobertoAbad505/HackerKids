//
//  HandTrackingStartView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 12/8/25.
//

import SwiftUI

struct HandTrackingStartView: View {
    @StateObject var viewModel = HandTrackingViewModel()

   var body: some View {
       ZStack {
           if viewModel.showCameraView {
               HandTrackingCameraView(viewModel: viewModel)
           } else {
               initialView
           }
       }
   }
    var initialView: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Vision Playground\n🕹️👾")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 80)
                .multilineTextAlignment(.center)
            if viewModel.cameraAuthorized {
                startVisionButton
            } else {
                requestPermissionButton
                Text("Camera access required to track hand gestures.")
                    .font(Font.footnote.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
        .meshAnimatedBackgroundSimple()
    }
    var startVisionButton: some View {
        HStack {
            Button(action: {
                viewModel.showCameraView = true
            }, label: {
                Image(systemName: "eye")
                    .font(.system(size: 25))
                Text("Start vision!")
                    .font(.title3)
            })
            .foregroundStyle(.white)
            .padding(.horizontal, 40)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 10, y: 10)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke((.white), lineWidth: 3)
        )
    }
    var requestPermissionButton: some View {
        HStack {
            Button(action: {
                viewModel.requestCameraAccess()
            }, label: {
                Image(systemName: "camera.circle")
                    .font(.system(size: 25))
                Text("Enable Camera Access")
                    .font(.title3)
            })
            .foregroundStyle(.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 10, y: 10)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke((.white), lineWidth: 3)
        )
    }
}


#Preview {
    HandTrackingStartView()
}
