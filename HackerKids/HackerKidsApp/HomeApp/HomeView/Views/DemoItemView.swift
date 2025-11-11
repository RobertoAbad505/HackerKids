//
//  DemoItemView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 11/11/25.
//

import SwiftUI

struct DemoItemView: View {
    let feature: FeatureModel
    let isPair: Bool
    init(feature: FeatureModel, _ pair: Bool = false) {
        self.feature = feature
        self.isPair = pair
    }
    var body: some View {
        VStack {
            Text(feature.icon)
                .font(Font.system(size: 60, weight: .bold))
            Text(feature.name)
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .padding(.horizontal)
        .frame(minWidth: 150, maxWidth: 180)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black, radius: 10, x: 10, y: 10)
    }
    var textDescription: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(feature.name)
                    .font(.body)
                    .fontWeight(.bold)
                Spacer()
            }
            Text(feature.lclstring)
                .font(.system(size: 12))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: 200)
            Spacer(minLength: 5)
            navigateButton
        }
        .padding()
        .padding(.vertical)
        .background(.ultraThinMaterial.opacity(0.5))
    }
    var navigateButton: some View {
        HStack {
            Image(systemName: "chevron.right")
                .font(.system(size: 15, weight: .medium))
            Text("Navegar!")
                .font(.system(size: 15, weight: .medium))
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
        .padding(.vertical, 30)
        .font(.system(size: 30))
    }
}
#Preview {
    DemoItemView(feature: .init(id: 1,
                                      name: "Prueba",
                                      description: "Prueba",
                                      lclstring: LocalizedStringResource("Prueba"),
                                      type: .pokemon,
                                      icon: "👽"))
}
