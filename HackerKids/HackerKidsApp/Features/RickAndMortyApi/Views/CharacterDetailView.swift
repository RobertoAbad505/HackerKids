//
//  CharacterDetailView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/5/25.
//
import Kingfisher
import SwiftUI

struct CharacterDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: RickAndMortyViewModel
    let character: RnMCharacter
    init(viewModel: RickAndMortyViewModel, character: RnMCharacter) {
        self.character = character
        self.viewModel = viewModel
    }
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    HStack{
                        Spacer()
                        KFImage(URL(string: character.image ?? "") ?? nil)
                            .placeholder({
                                Image(systemName: "person.fill.questionmark")
                            })
                            .cacheOriginalImage()
                            .resizable()
                            .frame(width: 300, height: 300)
                            .clipShape(.rect(cornerRadius: 25))
                        Spacer()
                    }
                    .padding(.top)
                    HStack {
                        Spacer()
                        Text(character.name ?? "")
                            .multilineTextAlignment(.center)
                            .font(.title)
                            .padding(.bottom)
                        Spacer()
                    }
                    .padding(.vertical)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke((.white), lineWidth: 3)
                    )
                    VStack {
                        Text("Status: \(character.status ?? "")")
                            .font(.title2)
                        Text("Species: \(character.species ?? "")")
                            .font(.title2)
                        Text("Gender: \(character.gender ?? "")")
                            .padding(.bottom)
                            .font(.title2)
                        HStack {
                            Image(systemName: "mappin.circle")
                                .font(.system(size: 35))
                            Text("Origin location: \n\(character.origin?.name ?? "")")
                                .font(.title2)
                        }
                        .padding(.bottom)
                        HStack {
                            Spacer()
                            Image(systemName: "mappin.and.ellipse.circle.fill")
                                .font(.system(size: 35))
                            Text("Current location: \n\(character.origin?.name ?? "")")
                                .font(.title2)
                            Spacer()
                        }
                    }
                    .padding(.vertical, 20)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke((.white), lineWidth: 3)
                    )
                    
                }
                .fontDesign(.monospaced)
            }
            .padding()
        }
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    withAnimation(.bouncy(duration: 1, extraBounce: 0.5)) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                }, label: {
                    Image(systemName: "arrow.left.circle.dotted")
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .animation(.interactiveSpring, value: true)
                })
                .padding(.trailing)
            })
        })
        .navigationBarBackButtonHidden(true)
        .foregroundStyle(.white)
        .background(Color.blue.opacity(0.5).ignoresSafeArea(edges: .all))
        .onAppear {
            viewModel.isNavigating = true
        }
    }
}

#Preview {
    CharacterDetailView(viewModel: .init(),
                        character: .init(id: 1,
                                         name: "Prueba",
                                         status: "Alive",
                                         species: "Especie",
                                         type: "Typo",
                                         gender: "Genero",
                                         image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                                         episode: [],
                                         url: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                                         created: "Created",
                                         origin: .init(name: "Earth",
                                                       url: ""),
                                         location: .init(name: "EarthLocation", url: "")))
}
