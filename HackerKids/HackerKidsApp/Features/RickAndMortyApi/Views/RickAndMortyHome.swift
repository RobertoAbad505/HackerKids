//
//  RickAndMortyHome.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/2/25.
//

import Kingfisher
import SwiftUI

struct RickAndMortyHome: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) private var presentationMode
    //view orientation and design
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var isLandscape: Bool = false
    @State private var isScrolling: Bool = false
    @State private var currentPage: String = "1"
    
    var backgroundColor: LinearGradient {
        LinearGradient(stops: [.init(color: .black, location: 0.25),
                               .init(color: .pink, location: 0.40),
                               .init(color: .purple, location: 0.55),
                               .init(color: .white, location: 0.70),
                               .init(color: .black, location: 0.90)
                              ],
                       startPoint: .top,
                       endPoint: .bottom)
    }
    
    var columns: [GridItem] {
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        let count = isIpad ? (isLandscape ? 5:4): (isLandscape ? 3:2)
        return Array(repeating: GridItem(.flexible()), count: count)
    }
    @ObservedObject var viewModel: RickAndMortyViewModel = .init()
    @State private var isAnimating = false
    
    init(_ appState: AppState) {
        self._viewModel = ObservedObject(initialValue: appState.rickAndMortyViewModel)
    }
    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.errorLoading {
                    scrollViewCurrentVersion
                } else {
                    errorView
                }
            }
            .background(Image("seaBluebackground").resizable().edgesIgnoringSafeArea(.all))
            .onAppear {
                if viewModel.charactersCatalog.isEmpty {
                    viewModel.fetchData()
                    updateOrientation()
                }
            }
            .onDisappear {
                if !viewModel.charactersCatalog.isEmpty {
                    appState.rickAndMortyViewModel = self.viewModel
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                print("orientation changed!")
                updateOrientation()
            }
            .modifier(ToolbarVisibilityModifier(isScrolling: isScrolling))
            .navigationBarTitle(
                !viewModel.isNavigating ? Text("Catalog: page \(currentPage) of \(viewModel.totalPages)"):Text("")
            )
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbar {
                if viewModel.isNavigating {
                    ToolbarItem(placement: .topBarLeading, content: {
                        Button(action: {
                            withAnimation(.bouncy(duration: 1, extraBounce: 0.5)) {
                                self.viewModel.isNavigating = false
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
                if !viewModel.isNavigating {
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
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    var errorView: some View {
        VStack(alignment: .center, spacing: 20) {
            header
            Spacer()
            VStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 72, weight: .bold))
                Text("Error loading our page!")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .padding(30)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            Spacer()
        }
        .padding()
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
    var scrollViewCurrentVersion: some View {
        VStack {
            if #available(iOS 18.0, *) {
                scrollView
                        .onScrollPhaseChange({ _, phase in
                            withAnimation(.easeInOut(duration: 2.3)) {
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
                scrollView
            }
        }
    }
    var scrollView: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(Array(viewModel.charactersCatalog.enumerated()), id: \.element.id) { index, character in
                        NavigationLink(destination: CharacterDetailView(viewModel: viewModel,character: character), label: {
                            CharacterCardView(viewModel: viewModel,character: character)
                                .navigationBarBackButtonHidden(true)
                        })
                       .onAppear {
                            if index == viewModel.charactersCatalog.count - 1 {
                                self.currentPage = "\(index / 20 + 1)"
                                viewModel.fetchData(true)
                            }
                        }
                    }
                }
                .padding()
                Spacer()
            }
        }
    }
    var header: some View {
        HStack(alignment: .firstTextBaseline) {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.primary)
                    .frame(width: 15, height: 25)
                    .fontWeight(.bold)
            })
            .padding(.leading)
            Spacer()
        }
    }
    private func updateOrientation() {
        self.isLandscape = UIDevice.current.orientation.isLandscape
    }
}

struct ToolbarVisibilityModifier: ViewModifier {
    let isScrolling: Bool

    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .toolbarVisibility(isScrolling ? .hidden : .visible, for: .navigationBar)
        } else {
            content
        }
    }
}
