//
//  RickAndMortyHome.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/2/25.
//

import SwiftUI

struct RickAndMortyHome: View {
    @ObservedObject var viewModel: RickAndMortyViewModel
    
    //view orientation and design
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var isLandscape: Bool = false
    var columns: [GridItem] {
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        let count = isIpad ? (isLandscape ? 5:4): (isLandscape ? 3:2)
        return Array(repeating: GridItem(.flexible()), count: count)
    }
    
    init(viewModel: RickAndMortyViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        NavigationView {
            VStack {
                Text("Rick and Morty API")
                    .font(.largeTitle)
                catalogPicker
                scrollView
            }
            .onAppear {
                viewModel.fetchData()
                updateOrientation()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                print("orientation changed!")
                updateOrientation()
            }
        }
    }
    var catalogPicker: some View {
        Picker("Select catalog",
               selection: $viewModel.queryObject,
               content: {
            ForEach(RickAndMortyQueryObject.allCases) { catalog in
                Text(catalog.rawValue).tag(catalog)
            }
        })
        .pickerStyle(SegmentedPickerStyle())
    }
    var scrollView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(viewModel.charactersCatalog.indices, id: \.self) { index in
                    getCharacterCard(character: viewModel.charactersCatalog[index])
                    .onAppear {
                        if index == viewModel.charactersCatalog.count - 3 {
                            viewModel.fetchData(true)
                        }
                    }
                }
            }
        }
    }
    private func getCharacterCard(character: RnMCharacter) -> some View {
        VStack {
            NavigationLink(destination: CharacterDetailView(character: character)) {
                VStack {
                    AsyncImage(url: URL(string: character.image ?? "")) { image in
                        image.resizable()
                    } placeholder: {
                        Image(systemName: "person.fill.questionmark")
                    }
                    .frame(width: 148, height: 148)
                    .clipShape(.rect(cornerRadius: 25))
                    Text(character.name ?? "")
                        .padding()
                }
                .background(Color.gray.opacity(0.3))
                .cornerRadius(25)
            }
        }
    }
    private func updateOrientation() {
        self.isLandscape = UIDevice.current.orientation.isLandscape
    }
}

#Preview {
    RickAndMortyHome(viewModel: RickAndMortyViewModel())
}
