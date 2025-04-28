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
    let character: RnMCharacter
    init(character: RnMCharacter) {
        self.character = character
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
                            .resizable()
                            .frame(width: 250, height: 250)
                            .clipShape(.rect(cornerRadius: 25))
                        Spacer()
                    }
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
                .padding()
            }
        }
        .foregroundStyle(.white)
        .background(Color.blue.opacity(0.5).ignoresSafeArea(edges: .all))
    }
    var header: some View {
        ZStack {
            HStack {
                Spacer()
                Text("Rick and Morty API")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "clear")
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .padding(3)
                        .clipShape(Circle())
                })
                .padding(.trailing)
            }
        }
    }
    /**
     {
         "id": 1,
         "name": "Rick Sanchez",
         "status": "Alive",
         "species": "Human",
         "type": "",
         "gender": "Male",
         "origin": {
             "name": "Earth (C-137)",
             "url": "https://rickandmortyapi.com/api/location/1"
         },
         "location": {
             "name": "Citadel of Ricks",
             "url": "https://rickandmortyapi.com/api/location/3"
         },
         "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
         "episode": [
             "https://rickandmortyapi.com/api/episode/1",
             "https://rickandmortyapi.com/api/episode/2",
             "https://rickandmortyapi.com/api/episode/3",
             "https://rickandmortyapi.com/api/episode/4",
             "https://rickandmortyapi.com/api/episode/5",
             "https://rickandmortyapi.com/api/episode/6",
             "https://rickandmortyapi.com/api/episode/7",
             "https://rickandmortyapi.com/api/episode/8",
             "https://rickandmortyapi.com/api/episode/9",
             "https://rickandmortyapi.com/api/episode/10",
             "https://rickandmortyapi.com/api/episode/11",
             "https://rickandmortyapi.com/api/episode/12",
             "https://rickandmortyapi.com/api/episode/13",
             "https://rickandmortyapi.com/api/episode/14",
             "https://rickandmortyapi.com/api/episode/15",
             "https://rickandmortyapi.com/api/episode/16",
             "https://rickandmortyapi.com/api/episode/17",
             "https://rickandmortyapi.com/api/episode/18",
             "https://rickandmortyapi.com/api/episode/19",
             "https://rickandmortyapi.com/api/episode/20",
             "https://rickandmortyapi.com/api/episode/21",
             "https://rickandmortyapi.com/api/episode/22",
             "https://rickandmortyapi.com/api/episode/23",
             "https://rickandmortyapi.com/api/episode/24",
             "https://rickandmortyapi.com/api/episode/25",
             "https://rickandmortyapi.com/api/episode/26",
             "https://rickandmortyapi.com/api/episode/27",
             "https://rickandmortyapi.com/api/episode/28",
             "https://rickandmortyapi.com/api/episode/29",
             "https://rickandmortyapi.com/api/episode/30",
             "https://rickandmortyapi.com/api/episode/31",
             "https://rickandmortyapi.com/api/episode/32",
             "https://rickandmortyapi.com/api/episode/33",
             "https://rickandmortyapi.com/api/episode/34",
             "https://rickandmortyapi.com/api/episode/35",
             "https://rickandmortyapi.com/api/episode/36",
             "https://rickandmortyapi.com/api/episode/37",
             "https://rickandmortyapi.com/api/episode/38",
             "https://rickandmortyapi.com/api/episode/39",
             "https://rickandmortyapi.com/api/episode/40",
             "https://rickandmortyapi.com/api/episode/41",
             "https://rickandmortyapi.com/api/episode/42",
             "https://rickandmortyapi.com/api/episode/43",
             "https://rickandmortyapi.com/api/episode/44",
             "https://rickandmortyapi.com/api/episode/45",
             "https://rickandmortyapi.com/api/episode/46",
             "https://rickandmortyapi.com/api/episode/47",
             "https://rickandmortyapi.com/api/episode/48",
             "https://rickandmortyapi.com/api/episode/49",
             "https://rickandmortyapi.com/api/episode/50",
             "https://rickandmortyapi.com/api/episode/51"
         ],
         "url": "https://rickandmortyapi.com/api/character/1",
         "created": "2017-11-04T18:48:46.250Z"
     }
     */
}

//#Preview {
//    CharacterDetailView()
//}
