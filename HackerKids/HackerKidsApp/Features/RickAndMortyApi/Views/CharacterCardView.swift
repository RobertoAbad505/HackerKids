//
//  CharacterCardView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/27/25.
//
import Kingfisher
import SwiftUI

struct CharacterCardView: View {
    let character: RnMCharacter

    var body: some View {
        VStack {
            NavigationLink(destination: CharacterDetailView(character: character)) {
                labelCard
            }
            .navigationBarBackButtonHidden(true)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    var labelCard: some View {
        VStack(alignment: .center, spacing: 0) {
            KFImage(URL(string: character.image ?? "") ?? nil)
                .placeholder({
                    Image(systemName: "person.fill.questionmark")
                })
                .resizable()
                .frame(width: 170, height: 170)
            Spacer()
            VStack {
                Text(character.name ?? "")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
                Text(character.origin?.name ?? "")
                    .font(.footnote)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: 170)
        }
    }
}

#Preview {
    CharacterCardView(character: .init(id: 1,
                                       name: "Test",
                                       status: "Alive",
                                       species: "Human",
                                       type: "Alien",
                                       gender: "Male",
                                       image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                                       episode: [""],
                                       url: "",
                                       created: "created at",
                                       origin: nil,
                                       location: nil))
}
