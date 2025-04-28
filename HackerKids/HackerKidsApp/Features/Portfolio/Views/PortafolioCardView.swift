//
//  PortafolioCardView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/25/25.
//

import SwiftUI

struct PortafolioCardView: View {
    let feature: FeatureModel
    let isPair: Bool
    init(feature: FeatureModel, _ pair: Bool = false) {
        self.feature = feature
        self.isPair = pair
    }
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            if isPair {
                iconsView
                textDescription
            } else {
                textDescription
                iconsView
            }
        }
        .frame(maxWidth: .infinity)
        .leftRoundedBorder(radius: 20, borderStyle: .ultraThinMaterial, corners: [.allCorners])
        .padding(.leading)
        .padding(.trailing, 4)
        .rotation3DEffect(.degrees(10),axis: (x: 0, y: isPair ? 0.5:-0.5, z: 0))
    }
    var textDescription: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(feature.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            Text(feature.description)
                .font(.callout)
                .multilineTextAlignment(.leading)
            Spacer()
            navigateButton
        }
        .padding()
        .padding(.vertical)
        .background(.ultraThinMaterial.opacity(0.5))
    }
    var navigateButton: some View {
        HStack {
            Image(systemName: "chevron.right")
                .font(.system(size: 20, weight: .medium))
            Text("Navegar!")
                .font(.headline)
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
    }
    var iconsView: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack(alignment: .lastTextBaseline) {
                Image(systemName: "mappin.circle")
                Image(systemName: "apple.logo")
            }
            HStack(alignment: .lastTextBaseline) {
                Image(systemName: "camera")
                Image(systemName: "network")
            }
        }
        .foregroundStyle(.ultraThinMaterial)
        .padding(.vertical, 20)
        .font(.system(size: 40))
        .frame(maxWidth: 125, maxHeight: .infinity)
    }
}

#Preview {
    PortafolioCardView(feature: .init(id: 1, name: "Prueba", description: "Prueba", type: .pokemon))
}
