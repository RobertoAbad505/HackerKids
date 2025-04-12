//
//  HomeView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 12/6/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: AboutAppViewModel = AboutAppViewModel()
    @ObservedObject var userViewModel: LoginViewModel = LoginViewModel()
    @State var infoView: Bool = false
    @State var loginView: Bool = false
    @State var gameRoute: GameRoute = .home
    @State var playerInfo: LocalUser?
    
    var body: some View {
        NavigationStack {
            VStack {
                activeProfile
                Spacer()
                title
                startButton
                challengeButton
                chatWithBTFriend
//                highScoresButton --> Create a single game view for the soup letter view
                apisDemoButton
                Spacer()
                infoButton
            }
            .padding(.top)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .onChange(of: SessionManager.shared.signedInUser) { user in
                if user == nil {
                    loginView = true
                    playerInfo = user
                }
            }
            .onAppear {
                #if ISDEBUG
                print("IS DEVELOPMENT TARGET")
                #else
                print("IS RELEASE TARGET")
                #endif
                SessionManager.shared.fetchLastSession(modelContext)
            }
            .navigationDestination(for: GameRoute.self) { route in
                switch route {
                case .game:
                    SoupChallengeView(onExit: { gameRoute = .home })
                case .challenge:
                    ChallengeToView(onExit: {
                        gameRoute = .home
                    })
                case .highScores:
                    VStack {
                        Text("High scores")
                    }
                case .home:
                    HomeView()
                }
            }
            .sheet(isPresented: $infoView) {
                ZStack {
                    AboutAppView(self.viewModel)
                }
                .edgesIgnoringSafeArea(.all)
            }
            .overlay {
                if loginView {
                    withAnimation(.default) {
                        LoginView(onExit: { self.loginView = false })
                    }
                }
            }
        }
    }
    var activeProfile: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                Text("Hi! \(playerInfo?.userName ?? "")")
            }
            Image(systemName: "person.fill")
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .padding(3)
                .background(UIManager.shared.backgroundGradient)
                .clipShape(Circle())
        }
        .padding()
        .onTapGesture {
            loginView.toggle()
        }
    }
    var title: some View {
        VStack {
            Text("Swift Skills")
                .font(.largeTitle)
            Text("by RobertSoft")
                .font(.subheadline)
        }
        .padding(.bottom, 20)
        .fontWeight(.bold)
        .rotation3DEffect(
            .degrees(20), // Ángulo de rotación
            axis: (x: 1, y: 0, z: 0)
        )
        .foregroundColor(.blue)
        .shadow(color: .gray, radius: 10, x: 5, y: 5) // Sombra para mayor profundidad
    }
    var startButton: some View {
        withAnimation(.easeInOut(duration: 0.2)) {
            NavigationLink(destination: SoupChallengeView(onExit: {
                self.gameRoute = .home
            }), label: {
                HomeButtonView(title: "Start game", icon: "play")
            })
        }
    }
    var challengeButton: some View {
        withAnimation(.easeInOut(duration: 0.2)) {
            NavigationLink(destination: ChallengeToView(onExit: {
                self.gameRoute = .home
            }), label: {
                HomeButtonView(title: "Vs challenge", icon: "flag.2.crossed")
            })
        }
    }
    var chatWithBTFriend: some View {
        withAnimation(.easeInOut(duration: 0.2)) {
            NavigationLink(destination: ChatWithBTFriendView(), label: {
                HomeButtonView(title: "Chat with a friend", icon: "bubble.left.and.text.bubble.right")
            })
        }
    }
    var highScoresButton: some View {
        withAnimation(.easeInOut(duration: 0.2)) {
            NavigationLink(destination: SoupChallengeView(onExit: {
                self.gameRoute = .highScores
            }), label: {
                HomeButtonView(title: "High scores", icon: "gamecontroller.circle")
            })
        }
    }
    var apisDemoButton: some View {
        withAnimation(.easeInOut(duration: 0.2)) {
            NavigationLink(destination: APISDemoView(), label: {
                HomeButtonView(title: "APIs Demo", icon: "network")
            })
        }
    }
    var infoButton: some View {
        Button(action: {
            infoView.toggle()
        }) {
            HStack(spacing: 0) {
                Image(systemName: "info.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                Text("about the app")
                    .setTitle3D(.subheadline)
                Spacer()
            }
        }
        .padding(.leading)
    }
}
enum GameRoute: Hashable {
    case home
    case game
    case challenge
    case highScores
}

#Preview {
    HomeView()
        .modelContainer(for: LocalUser.self, inMemory: true)
}
