//
//  AirDrawingCanvasView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/7/26.
//

import SwiftUI

struct AirDrawingCanvasView: View {
    @ObservedObject var viewModel: HandTrackingViewModel

    var body: some View {
        GeometryReader { geo in
            Canvas { context, _ in

                // 👇 Helper local
                func scale(_ point: CGPoint) -> CGPoint {
                    CGPoint(
                        x: point.x * geo.size.width,
                        y: point.y * geo.size.height
                    )
                }

                for stroke in viewModel.drawingStrokes {
                    var path = Path()
                    guard let first = stroke.points.first else { continue }

                    path.move(to: scale(first))
                    stroke.points.dropFirst().forEach {
                        path.addLine(to: scale($0))
                    }

                    context.stroke(
                        path,
                        with: .color(stroke.color.swiftUIColor),
                        lineWidth: stroke.baseLineWidth
                    )
                }

                // Trazo activo
                if let first = viewModel.currentDrawingPath.first {
                    var path = Path()
                    path.move(to: scale(first))
                    viewModel.currentDrawingPath.dropFirst().forEach {
                        path.addLine(to: scale($0))
                    }

                    context.stroke(
                        path,
                        with: .color(viewModel.currentColor.swiftUIColor),
                        lineWidth: viewModel.currentLineWidth
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }
}


#Preview {
    AirDrawingCanvasView(viewModel: .init())
}
