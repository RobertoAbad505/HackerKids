//
//  RickAndMortyHome.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/2/25.
//

import Kingfisher
import SwiftUI

struct RickAndMortyHome: View {
    @ObservedObject var viewModel: RickAndMortyViewModel
    @Environment(\.presentationMode) private var presentationMode
    //view orientation and design
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var isLandscape: Bool = false
    
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
    
    
    init(viewModel: RickAndMortyViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        NavigationView {
            VStack {
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
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
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
            VStack {
                header
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.charactersCatalog.indices, id: \.self) { index in
                        CharacterCardView(character: viewModel.charactersCatalog[index])
                        .onAppear {
                            if index == viewModel.charactersCatalog.count - 1 {
                                viewModel.fetchData(true)
                            }
                        }
                    }
                }
                .padding()
            }
        }.background(Image("seaBluebacground").edgesIgnoringSafeArea(.all))
    }
    var header: some View {
        HStack(alignment: .firstTextBaseline) {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.primary)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
            })
            .padding(.leading)
            Spacer()
            Text("Rick and Morty API")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            Spacer()
        }
    }
    private func updateOrientation() {
        self.isLandscape = UIDevice.current.orientation.isLandscape
    }
}

#Preview {
    RickAndMortyHome(viewModel: RickAndMortyViewModel())
}
