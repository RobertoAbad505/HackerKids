//
//  MovieBrowserView.swift
//  MovieBrowserApp
//
//  Created by Roberto Ramirez on 10/9/25.
//

import SwiftUI


struct MovieBrowserView: View {
    @ObservedObject var viewModel: MoviesViewModel = .init()
    
    
    //configuration view
    let columns: [GridItem] = [
        GridItem(.flexible(minimum: 110)),
        GridItem(.flexible(minimum: 110))
    ]
    let rows: [GridItem] = [
        GridItem(.flexible(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                activeView
            }
        }
        .task {
            //ASYNC CALL
            await viewModel.fetchMostPopularMovies()
        }
    }
    
    var activeView: some View {
        VStack {
            switch viewModel.presenterState {
            case PresenterState.loading:
                loadingView
            case PresenterState.success:
                mainPage
            case PresenterState.failure:
                errorPage
            }
        }
    }
    
    var mainPage: some View {
        ScrollView(.vertical) {
            Text("TMDB Movie Database")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(20)
            VStack(alignment: .leading, spacing: 30) {
                topTenMovies
                mostPopularMovies
                popularPlaylist
                moviesCatalog
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    var mostPopularMovies: some View {
        VStack(alignment: .leading) {
            Text("🍿🎥Most Popular Movies")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading, 10)
            ScrollView(.horizontal, content: {
                LazyHGrid(rows: rows) {
                    ForEach(viewModel.movies, id: \.id) { movie in
                        MovieItemView(movie: movie)
                    }
                }
                .padding(.leading, 20)
            })
        }
    }
    var topTenMovies: some View {
        VStack(alignment: .leading) {
            Text("🍿🎥Top \(viewModel.topTenMovies.count) Movies")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading, 10)
            ScrollView(.horizontal, content: {
                LazyHGrid(rows: rows) {
                    ForEach(viewModel.topTenMovies, id: \.id) { movie in
                        MovieItemView(movie: movie)
                    }
                }
                .padding(.leading, 20)
            })
        }
    }
    var popularPlaylist: some View {
        VStack(alignment: .leading) {
            if !viewModel.popularPlaylist.isEmpty {
                Text("🍿🎥Top playlist movies")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.leading, 10)
                ScrollView(.horizontal, content: {
                    LazyHGrid(rows: rows) {
                        ForEach(viewModel.popularPlaylist, id: \.id) { movie in
                            MovieItemView(movie: movie)
                        }
                    }
                    .padding(.leading, 20)
                })
            }
            Button(action: {
                viewModel.fetchNextPage()
            }, label: {
                Text("Fetch next page!")
                    .font(Font.caption.bold())
                    .padding(10)
                    .border(.white, width: 1)
            })
        }
    }
    var moviesCatalog: some View {
        VStack(alignment: .leading) {
            if !viewModel.moviesCatalog.isEmpty {
                Text("🍿🎥 Movies catalog")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.leading, 10)
                ScrollView(.vertical, content: {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.moviesCatalog, id: \.id) { movie in
                            MovieItemView(movie: movie, .landscapeLeft)
                        }
                    }
                    .padding(.leading, 20)
                })
            }
            Button(action: {
                viewModel.fetchGalleryMovies()
            }, label: {
                Text("Watch more movies catalog!")
                    .font(Font.footnote.bold())
                    .padding(10)
                    .border(.white, width: 1)
            })
        }
    }
    
    var errorPage: some View {
        VStack {
            Text("‼️ Some error happened trying to fetch the data. Try again later.❌")
        }
        .padding(20)
    }
    var loadingView: some View {
        VStack {
            ProgressView()
            Text("Loading . . .")
        }
        .padding(20)
    }
}

#Preview {
    MovieBrowserView()
}
