//
//  PokemonAPIView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/7/25.
//

import SwiftUI

struct PokemonAPIView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var appState: AppState
    @State var backgroundMusic: Bool = true
    @State private var isScrolling: Bool = false
    let backgrounMusicName: String = "pokeaudio"
    
    var body: some View {
        NavigationView {
            VStack {
                if !appState.pokemonViewModel.errorFetch {
                    scrollViewCurrentVersion
                } else {
                    errorView
                }
            }
            .background(Image("pokemonBg").edgesIgnoringSafeArea(.all))
            .task {
                print("🚀Initial task launched . . . !")
                if self.backgroundMusic {
//                    self.backgroundMusic = audioManager.playBackgroundMusic(named: backgrounMusicName)
                }
                if appState.pokemonViewModel.pokemonList.isEmpty {
                    appState.pokemonViewModel.fetchPokedexPage()
                }
                print("✅Initial task finished . . . !")
            }
            .onDisappear {
                if !appState.pokemonViewModel.navigateDetail {
                    audioManager.stop()
                }
            }
            .modifier(ToolbarVisibilityModifier(isScrolling: isScrolling))
            .navigationBarTitle(
                !appState.pokemonViewModel.navigateDetail ? Text("👾SwiftUI Lists"): Text("")
            )
            .toolbar {
                if appState.pokemonViewModel.navigateDetail {
                    ToolbarItem(placement: .topBarLeading, content: {
                        Button(action: {
                            withAnimation(.bouncy(duration: 1, extraBounce: 0.5)) {
                                self.appState.pokemonViewModel.navigateDetail = false
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
                if !appState.pokemonViewModel.navigateDetail {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation(.bouncy(duration: 1, extraBounce: 0.5)) {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }, label: {
                            Image(systemName: "clear")
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                        })
                    }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    var scrollViewCurrentVersion: some View {
        VStack {
            if #available(iOS 18.0, *) {
                pokedexScrollView
                        .onScrollPhaseChange({ _, phase in
                            withAnimation(.easeInOut(duration: 2)) {
                                switch phase {
                                case .idle:
                                    isScrolling = false
                                case .tracking, .animating, .decelerating:
                                    isScrolling = true
                                default:
                                    break
                                }
                            }
                        })
            } else {
                pokedexScrollView
            }
        }
        .background(
            NavigationLink(
                destination: PokemonDetailView(viewModel: self.appState.pokemonViewModel),
                isActive: $appState.pokemonViewModel.navigateDetail,
                label: { EmptyView() }
            )
            .hidden()
        )
    }
    var pokedexScrollView: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: [GridItem.init(.flexible())]) {
                    ForEach(Array(appState.pokemonViewModel.pokemonList.enumerated()), id: \.element.id) { index, pokemon in
                        PokedexItemView(viewModel: appState.pokemonViewModel,item: pokemon, onSelected: {
                            //play selected pokemon sound
                            audioManager.playSoundEffect(named: "coinFx")
                            appState.pokemonViewModel.selectedPokemon = pokemon
                            // Delay para permitir que el sonido suene antes de navegar
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                appState.pokemonViewModel.navigateDetail = true
                                appState.pokemonViewModel.fetchPokemonDetail()
                            }
                        })
                        .onAppear {
                            if index == appState.pokemonViewModel.pokemonList.count - 1 && !appState.pokemonViewModel.isLoading {
                                print("Fetch next page . . .")
                                appState.pokemonViewModel.fetchPokedexPage()
                            }
                        }
                        .shadow(color: Color.black, radius: 3, x: 10, y: 10)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
        }
    }
    var titleHeader: some View {
        HStack {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.primary)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
            })
            Spacer()
            Button(action: {
                withAnimation {
                    if self.backgroundMusic {
                        audioManager.stop()
                        self.backgroundMusic = false
                    } else {
                        self.backgroundMusic = audioManager.playBackgroundMusic(named: backgrounMusicName)
                    }
                }
            }, label: {
                Image(systemName: (self.backgroundMusic ? "speaker.wave.2.circle.fill":"speaker.slash.circle.fill"))
                    .font(.system(size: 30))
                    .foregroundStyle(.white)
            })
            .hidden()
        }
        .padding(.horizontal)
    }
    var errorView: some View {
        VStack {
            Spacer()
            titleHeader
            Text("Error loading data!")
                .setTitle3D(.largeTitle)
            Spacer()
        }
    }
}

#Preview {
    PokemonAPIView()
}
