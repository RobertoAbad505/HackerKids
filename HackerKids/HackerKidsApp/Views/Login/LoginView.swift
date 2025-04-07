//
//  LoginView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/2/25.
//
import GoogleSignInSwift
import SwiftUI

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var cameraManager = CameraManager()
    @ObservedObject var viewModel: LoginViewModel
    @State private var accountCreated: Bool = false
    @Environment(\.presentationMode) private var presentationMode
    public var onExit: () -> Void = { }
    init(onExit: @escaping (() -> Void)) {
        self.viewModel = LoginViewModel()
        self.onExit = onExit
    }
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .center) {
                    VStack {
                        exitButton
                        Spacer()
                        if viewModel.userSession {
                            loggedUserView
                        } else {
                            createUser
                            loginWithSocial
                        }
                    }
                    .padding()
                    Spacer()
                    if viewModel.userSession {
                        signOffLink
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .onAppear {
            viewModel.startLogin(modelContext)
        }
        .popover(isPresented: $accountCreated, content: {
            VStack {
                Text("Usuario creado con exito!✔️")
            }
            .onTapGesture {
                self.accountCreated.toggle()
            }
        })
    }
    var exitButton: some View {
        HStack {
            Spacer()
            Button(action: {
                onExit()
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "clear")
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .padding(3)
                    .background(UIManager.shared.backgroundGradient)
                    .clipShape(Circle())
            })
        }
    }
    var loggedUserView: some View {
        VStack(alignment: .center) {
            if let img = viewModel.playerImg {
                img
                    .resizable()
                    .frame(width: 110, height: 110)
                    .padding(30)
                    .background(.thinMaterial)
                    .clipShape(Circle())
                    .padding(10)
                    .background(UIManager.shared.backgroundGradient)
                    .clipShape(Circle())
                    .padding(.bottom, 10)
                
            }
            Text("Player name:")
            Text(viewModel.player?.name ?? "N/A").bold().padding(.bottom)
            Text("account email:")
            Text(viewModel.player?.email ?? "N/A").bold()
            Spacer()
        }
        .padding()
    }
    var createUser: some View {
        CreateAccountView(self.viewModel)
    }
    var loginWithSocial: some View {
        VStack {
            Text("Or get login by using one of these")
            HStack {
                googleSignInButton
                Button(action: {
//                    openUrl(source)
                }, label: {
                    Image("googleIcon")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding()
                        .background(Color.white)
                        .foregroundStyle(Color.white)
                        .clipShape(Circle())
                })
                .background(LinearGradient(colors: [.white, .gray, .white, .gray], startPoint: .bottomLeading, endPoint: .top))
                .clipShape(Circle())
                .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 5, y: 5)
                Button(action: {
//                    openUrl(source)
                }, label: {
                    Image("gitIcon")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding()
                        .background(Color(red: 27 / 255, green: 31 / 255, blue: 35 / 255))
                        .foregroundStyle(Color.white)
                        .clipShape(Circle())
                })
                .padding(1)
                .background(LinearGradient(colors: [.white, .gray, .white, .gray], startPoint: .bottomLeading, endPoint: .top))
                .clipShape(Circle())
                .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 5, y: 5)
            }
        }
        .padding(.top, 150)
    }
    var signOffLink: some View {
        VStack {
            Button(action: {
                viewModel.signOff(modelContext)
            }, label: {
                HStack {
                    Image(systemName: "person.crop.circle.badge.xmark")
                    Text("Sign Off")
                }
                .foregroundStyle(.white)
                .font(.callout)
                .fontWeight(.bold)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
            })
            .frame(maxWidth: .infinity)
        }
        .background(Color.red)
        .cornerRadius(25)
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
    var googleSignInButton: some View {
        VStack {
            ZStack {
                GoogleSignInButton(scheme: .light,
                                   style: .icon,
                                   state: .normal,
                                   action: viewModel.handleGoogleSignIn)
            }
            .background(Color.white)
            .clipShape(Circle())
        }
    }
}

#Preview {
    LoginView(onExit: {})
}
