//
//  PokemonDetailView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/11/25.
//
import Kingfisher
import SwiftUI

struct PokemonDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.colorScheme) var colorScheme
    var index: Int = 0
    @ObservedObject var viewModel: PokemonApiViewModel
    var gradient: LinearGradient {
     return LinearGradient(stops: [
        Gradient.Stop(color: .pink, location: 0.20),
        Gradient.Stop(color: .pink.opacity(0.7), location: 0.30),
        Gradient.Stop(color: .purple, location: 0.50),
     ], startPoint: .bottom, endPoint: .topTrailing)
    }
    @State var pokemonColorsBYType: [Color] = []
    @State var inspectResponse: Bool = false
    let range: ClosedRange<Double>
    var attakColumns: [GridItem] {
        return [GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible())]
    }
    
    init(viewModel: PokemonApiViewModel) {
        self.viewModel = viewModel
        range = 0...100
    }
    var body: some View {
        VStack {
            ScrollView {
                imageTopHeader
                descriptionView
                spritesScrollView
                pokemonStats
                pokemonMoves
                inspectResponseView
                disclosureText
            }
            .edgesIgnoringSafeArea(.top)
            .background(getBackgroundGradient())
        }
        .foregroundStyle(getReverseThemeForeground())
        .fontDesign(.monospaced)
        .toolbar {
            if viewModel.navigateDetail {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                        withAnimation(.bouncy(duration: 1, extraBounce: 1.5)) {
                            self.viewModel.navigateDetail = false
                        }
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.white)
                            .frame(width: 15, height: 25)
                            .fontWeight(.bold)
                    })
                    .padding(.leading)
                })
            }
        }
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .foregroundStyle(.white)
    }
    var disclosureText: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("All data is fetched from an open source API provided by")
                .font(.footnote)
                .foregroundColor(.white)
                .fontWeight(.bold)
            Button(action: {
                guard let pokemonDocs = URL(string: "https://pokeapi.co/docs/v2") else { return }
                // Verificar si el dispositivo puede abrir la URL
                if UIApplication.shared.canOpenURL(pokemonDocs) {
                    UIApplication.shared.open(pokemonDocs, options: [:], completionHandler: nil)
                }
            }, label: {
                Text("PokeAPI.co")
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
            })
            Spacer()
        }
        .padding()
    }
    var exitButton: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "clear")
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .padding(3)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                })
            }
            Spacer()
        }.padding(.trailing, 15)
    }
    var imageTopHeader: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                if let gifUrl = URL(string: viewModel.selectedPokemon.pokedexDetail?.sprites?.other?.showdown?.front_default ?? "") {
                    KFAnimatedImage(gifUrl)
                        .cacheOriginalImage()
                        .scaledToFit()
                        .frame(width: 190, height: 220)
                }
            }
        }
        .padding(EdgeInsets(top: 160, leading: 20, bottom: 10, trailing: 20))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .edgesIgnoringSafeArea(.all)
    }
    var descriptionView: some View {
        VStack(spacing: 15) {
            Text((viewModel.selectedPokemon.pokemon.name ?? "").capitalizingFirstLetter())
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)
            HStack(alignment: .top) {
                VStack(alignment: .center) {
                    Text("📏Height")
                    Text("\(viewModel.selectedPokemon.pokedexDetail?.height ?? 0)\"")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                Spacer()
                VStack {
                    Text("⚖️Weight")
                    Text("\(viewModel.selectedPokemon.pokedexDetail?.weight ?? 0) lbs")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                Spacer()
                VStack(alignment: .center) {
                    Text("⚛️Species")
                    Text("\(viewModel.selectedPokemon.pokedexDetail?.species?.name ?? "")".capitalizingFirstLetter())
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            HStack(alignment: .top) {
                Spacer()
                VStack(alignment: .center) {
                    Text("Types")
                    LazyVGrid(columns: self.getTypeColumns(), spacing: 15) {
                        ForEach(viewModel.selectedPokemon.pokedexDetail?.types ?? [], id: \.self) { pokeType in
                            getTypeView(pokeType)
                                .foregroundStyle(getTypeColor(pokeType))
                        }
                    }
                }
                Spacer()
            }
            .padding(.top)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .background(.thinMaterial.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 50))
        .padding(15)
    }
    var spritesScrollView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("📸 Sprites")
                .font(.headline)
                .fontWeight(.bold)
                .padding(30)
            ScrollView(.horizontal, content: {
                HStack(alignment: .center, spacing: 10) {
                    //base img
                    if let imgUrl = URL(string: viewModel.selectedPokemon.pokedexDetail?.sprites?.front_default ?? "") {
                        KFImage(imgUrl)
                            .placeholder {
                                ProgressView()
                            }
                            .retry(maxCount: 3, interval: .seconds(2))
                            .cacheOriginalImage()
                            .fade(duration: 0.25)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
//                    if let imgHome = URL(string: viewModel.selectedPokemon.pokedexDetail?.sprites?.other?.dream_world?.front_default ?? "") {
//                        KFImage(imgHome) //Can't download .svg IMAGES
//                            .placeholder {
//                                ProgressView()
//                                    .border(.green, width: 2)
//                            }
//                            .retry(maxCount: 3, interval: .seconds(2))
//                            .cacheOriginalImage()
//                            .fade(duration: 0.25)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 200, height: 180)
//                    }
                    if let imgDreamWorld = URL(string: viewModel.selectedPokemon.pokedexDetail?.sprites?.other?.official_artwork?.front_default ?? "") {
                        KFImage(imgDreamWorld)
                            .placeholder {
                                ProgressView()
                            }
                            .retry(maxCount: 3, interval: .seconds(2))
                            .cacheOriginalImage()
                            .fade(duration: 0.25)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    if let imgUrl = URL(string: viewModel.selectedPokemon.pokedexDetail?.sprites?.other?.showdown?.front_default ?? "") {
                        KFAnimatedImage(imgUrl)
                            .cacheOriginalImage()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                    if let imgUrl = URL(string: viewModel.selectedPokemon.pokedexDetail?.sprites?.other?.showdown?.back_default ?? "") {
                        KFAnimatedImage(imgUrl)
                            .cacheOriginalImage()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                    VStack(alignment: .center) {
                        Text("Shiny")
                        HStack {
                            //base shiny
                            if let imgUrl = URL(string: viewModel.selectedPokemon.pokedexDetail?.sprites?.front_shiny ?? "") {
                                KFImage(imgUrl)
                                    .placeholder {
                                        ProgressView()
                                    }
                                    .retry(maxCount: 3, interval: .seconds(2))
                                    .cacheOriginalImage()
                                    .fade(duration: 0.25)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            //other.home
                            if let imgUrl = URL(string: viewModel.selectedPokemon.pokedexDetail?.sprites?.other?.home?.front_shiny ?? "") {
                                KFImage(imgUrl)
                                    .placeholder {
                                        ProgressView()
                                    }
                                    .retry(maxCount: 3, interval: .seconds(2))
                                    .cacheOriginalImage()
                                    .fade(duration: 0.25)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            //other.artwork missing
                            if let imgDreamWorld = URL(string: viewModel.selectedPokemon.pokedexDetail?.sprites?.other?.official_artwork?.front_shiny ?? "") {
                                KFImage(imgDreamWorld)
                                    .placeholder {
                                        ProgressView()
                                    }
                                    .retry(maxCount: 3, interval: .seconds(2))
                                    .cacheOriginalImage()
                                    .fade(duration: 0.25)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            //other.showdown
                            if let imgUrl = URL(string: viewModel.selectedPokemon.pokedexDetail?.sprites?.other?.showdown?.front_shiny ?? "") {
                                KFAnimatedImage(imgUrl)
                                    .cacheOriginalImage()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            }
                            if let imgUrl = URL(string: viewModel.selectedPokemon.pokedexDetail?.sprites?.other?.showdown?.back_shiny ?? "") {
                                KFAnimatedImage(imgUrl)
                                    .cacheOriginalImage()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding(.trailing, 20)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 250)
            })
        }
        .background(Color.white.opacity(0.1))
        .background(.thinMaterial.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 45))
        .padding(15)
    }
    var pokemonStats: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("📊 Base stats")
                .font(.headline)
                .fontWeight(.bold)
                .padding()
            ForEach(viewModel.selectedPokemon.pokedexDetail?.stats ?? [], id: \.self) { stat in
                HStack(alignment: .center, spacing: 0) {
                    Text(stat.stat?.name ?? "")
                        .font(.caption)
                        .fixedSize(horizontal: true, vertical: true)
                        .frame(maxWidth: 105)
                    VStack(alignment: .center, spacing: 0) {
                        Text("\(stat.base_stat ?? 0)")
                            .font(.footnote)
                        Slider(value: .constant(Double(stat.base_stat ?? 0)), in: range)
                            .tint(getStatColor(stat))
                            .scaleEffect(0.85)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .background(.thinMaterial.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 45))
        .padding(15)
    }
    var pokemonMoves: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("🗡️ Battle moves")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.bottom)
                .fontWeight(.bold)
            LazyVGrid(columns: self.attakColumns, spacing: 5) {
                ForEach(viewModel.selectedPokemon.pokedexDetail?.moves ?? [], id: \.self) { pokeMove in
                    HStack {
                        Text("⚔ \(pokeMove.move?.name ?? "")")
                            .fixedSize(horizontal: true, vertical: true)
                            .font(.footnote)
                    }
                    .padding(10)
                    .background(.ultraThinMaterial.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 35))
                    .foregroundStyle(getReverseThemeForeground())
                }
                
            }
        }
        .padding()
    }
    var inspectResponseView: some View {
        VStack(alignment: .center, spacing: 20) {
            Button(action: {
                withAnimation {
                    inspectResponse.toggle()
                }
            }, label: {
                HStack {
                    Spacer()
                    Text(inspectResponse ? "✅ Okay!" :"🔎👀 Inspeccionar JSON response")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.white) // Color dinámico
                    Spacer()
                }
                .padding()
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke((.white), lineWidth: 3)
                )
            })
            .padding(.vertical, 20)
            .padding(.horizontal)
            if inspectResponse {
                CodeBlockView(code: viewModel.readResponse(), size: 12)
            }
        }
    }
    func getReverseThemeForeground() -> Color {
        return colorScheme == .dark ? .white : .black
    }
    func getTypeView(_ type: PokemonType) -> some View {
        return VStack(alignment: .center, spacing: 5) {
            getTypeIcon(type)
                .resizable()
                .frame(width: 25, height: 25)
            Text(type.type?.name ?? "")
                .font(.footnote)
                .fontWeight(.bold)
        }
    }
    func getTypeColor(_ type: PokemonType) -> Color {
        switch type.type?.name ?? "" {
        case "electric": return .yellow
        case "fire": return .red
        case "normal": return .gray
        case "flying": return .blue
        case "grass": return .green
        case "poison": return .purple
        case "water": return .blue.opacity(0.7)
        case "ghost": return .cyan
        case "dragon": return .indigo
        case "bug": return .green
        default: return .gray
        }
    }
    func getStatColor(_ stat: PokemonBaseStats) -> Color {
        switch stat.stat?.name ?? "" {
        case "hp"
            : Color.green
        case "attack"
            : Color.red
        case "defense"
            : Color.yellow
        case "special-attack"
            : Color.purple
        case "special-defense"
            : Color.blue
        case "speed"
            : Color.orange
        default: Color.gray
        }
    }
    func getTypeIcon(_ type: PokemonType) -> Image {
        switch type.type?.name ?? "" {
        case "electric":  return Image(systemName: "bolt.circle.fill")
        case "fire": return Image(systemName: "flame.circle.fill")
        case "normal": return Image(systemName: "o.circle.fill")
        case "flying": return Image(systemName: "bird.circle.fill")
        case "grass": return Image(systemName: "leaf.circle.fill")
        case "poison": return Image(systemName: "ladybug.slash.circle.fill")
        case "water": return Image(systemName: "drop.circle.fill")
        case "ghost": return Image(systemName: "ghost.circle.fill")
        case "dragon": return Image(systemName: "dragon.circle.fill")
        default: return Image(systemName: "questionmark.circle.fill")
        }
    }
    func getTypeColumns() -> [GridItem] {
        var columns: Int = viewModel.selectedPokemon.pokedexDetail?.types?.count ?? 1
        if columns > 4 {
            columns = 4
        }
        return Array(repeating: GridItem(.flexible()), count: columns)
    }
    func getBackgroundGradient() -> LinearGradient {
        let defaultBg = LinearGradient(stops: [
            Gradient.Stop(color: .yellow, location: 0.20),
            Gradient.Stop(color: .black.opacity(0.7), location: 0.30),
            Gradient.Stop(color: .blue, location: 0.50),
         ], startPoint: .bottom, endPoint: .topTrailing)
        if let typeColor = viewModel.selectedPokemon.pokedexDetail?.types?.first {
            let color = getTypeColor(typeColor)
            switch typeColor.type?.name ?? "" {
            case "electric":
                return LinearGradient(stops: [
                    Gradient.Stop(color: .yellow, location: 0.20),
                    Gradient.Stop(color: .black, location: 0.30),
                    Gradient.Stop(color: .white, location: 0.75),
                    Gradient.Stop(color: .blue, location: 0.95),
                 ], startPoint: .bottom, endPoint: .topTrailing)
            case "fire":
                return LinearGradient(stops: [
                    Gradient.Stop(color: .red, location: 0.20),
                    Gradient.Stop(color: .black, location: 0.40),
                    Gradient.Stop(color: .white, location: 0.75),
                    Gradient.Stop(color: .orange, location: 0.85),
                    Gradient.Stop(color: .pink, location: 0.95),
                 ], startPoint: .bottom, endPoint: .topTrailing)
            case "grass":
                return LinearGradient(stops: [
                    Gradient.Stop(color: .green, location: 0.20),
                    Gradient.Stop(color: .black, location: 0.40),
                    Gradient.Stop(color: .white, location: 0.75),
                    Gradient.Stop(color: .blue, location: 0.85),
                    Gradient.Stop(color: .green, location: 0.95),
                 ], startPoint: .bottom, endPoint: .topTrailing)
            default: return defaultBg
            }
        }
        return defaultBg
    }
}

#Preview {
    PokemonDetailView(viewModel: .init())
}
