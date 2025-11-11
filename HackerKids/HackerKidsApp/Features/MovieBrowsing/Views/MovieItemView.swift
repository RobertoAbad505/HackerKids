//
//  MovieItemView.swift
//  MovieBrowserApp
//
//  Created by Roberto Ramirez on 10/12/25.
//

import SwiftUI
import Kingfisher

struct MovieItemView: View {
    @State var navigate: Bool = false
    let movie: MovieModel
    let designOrientation: UIDeviceOrientation
    @State var image: UIImage?
    
    init(movie: MovieModel,_ orientation: UIDeviceOrientation = .portrait) {
        self.movie = movie
        self.designOrientation = orientation
    }
    var body: some View {
        NavigationLink(destination: MovieDetailView(movie: self.movie), isActive: $navigate) {
            VStack(alignment: .center) {                
                KFImage(movie.getPosterURL() ?? nil)
                    .placeholder({
                        ProgressView()
                    })
                    .resizable()
                    .frame(width: designOrientation == .portrait ? 250:200,
                           height: designOrientation == .portrait ? 250:200
                    )
                VStack(alignment: .leading) {
                    Text("🎥\(movie.originalTitle ?? "")")
                        .font(Font.caption.bold())
                }
            }
        }
        .onTapGesture {
            self.navigate.toggle()
        }
    }
}

#Preview {
    
    MovieItemView(movie: .init(adult: false,
                                 backdropPath: "",
                                 genreIds: [],
                                 id: 1,
                                 originalTitle: "Title",
                                 overview: "Overview",
                                 releaseDate: "date",
                                 voteAverage: 0.50,
                                 voteCount: 999,
                                 posterPath: ""))
}
