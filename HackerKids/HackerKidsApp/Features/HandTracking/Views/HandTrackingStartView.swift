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
               VStack(spacing: 20) {
                   Text("Hand Tracking")
                       .font(.largeTitle)
                       .bold()

                   if viewModel.cameraAuthorized {
                       Button("Start Camera") {
                           viewModel.showCameraView = true
                       }
                       .buttonStyle(.borderedProminent)

                   } else {
                       Button("Enable Camera Access") {
                           viewModel.requestCameraAccess()
                       }
                       .buttonStyle(.bordered)

                       Text("Camera access required to track hand gestures.")
                           .font(.caption)
                           .foregroundStyle(.secondary)
                   }
               }
           }
       }
   }
}


#Preview {
    HandTrackingStartView()
}
