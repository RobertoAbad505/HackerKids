//
//  WeatherDataView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/27/25.
//

import SwiftUI

struct WeatherDataView: View {
    let icon: String
    let header: String
    let value: String

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Text(header)
                .font(.footnote)
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            HStack(alignment: .center, spacing: 5) {
                Text("\(value)")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                Image(systemName: icon)
                    .font(.system(size: 37))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#Preview {
    WeatherDataView(icon: "icon", header: "Header", value: "VALUE")
}
