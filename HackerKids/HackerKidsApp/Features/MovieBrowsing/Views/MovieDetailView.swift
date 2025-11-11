//
//  MovieDetailView.swift
//  MovieBrowserApp
//
//  Created by Roberto Ramirez on 10/12/25.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: MovieModel
    init(movie: MovieModel) {
        self.movie = movie
    }
    var body: some View {
        ScrollView(.vertical) {
            ZStack {
                VStack {
                    AsyncImage(url: movie.getBackdropURL() ?? nil){ result in
                        result.image?
                            .resizable()
                    }
                    .frame(maxHeight: 430)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack(alignment: .leading) {
                    Spacer(minLength: 350)
                    VStack(alignment: .leading) {
                        AsyncImage(url: movie.getPosterURL() ?? nil, content: { result in
                            result
                                .resizable()
                        }, placeholder: {
                            ProgressView()
                        })
                        .frame(width: 250, height: 250)
                        .padding(.bottom, 40)
                        VStack(alignment: .leading, spacing: 30) {
                            Text("🎥 \(movie.originalTitle ?? "")")
                                .font(Font.headline.bold())
                            Text("overview:\n\(movie.overview ?? "")")
                                .font(Font.subheadline)
                            Text("release date:\n\(movie.releaseDate ?? "")")
                                .font(Font.subheadline)
                            Text("Vote average:\n\(String(format: "%.1f", movie.voteAverage ?? 0.0))\t\(String(repeating: "⭐", count: Int(movie.voteAverage ?? 0.0)))")
                                .font(Font.title2.bold())
                        }
                        .padding(.bottom)
                    }
                    Spacer()
                }
                .padding(20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    MovieDetailView(movie: .init(adult: false,
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
