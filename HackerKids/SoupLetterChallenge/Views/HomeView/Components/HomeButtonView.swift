//
//  HomeButtonView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 12/6/24.
//

import SwiftUI

struct HomeButtonView: View {
    var title: String
    var icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
        }
        .font(.title2)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity) // Ocupa todo el ancho disponible
        .background(UIManager.shared.backgroundGradient)
        .cornerRadius(20)
        .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 5, y: 5)
        .padding(.horizontal, 40) // Espaciado lateral
        .scaleEffect(1.0) // Efecto inicial
    }
}

#Preview {
    HomeButtonView(title: "title", icon: "trophy")
}
