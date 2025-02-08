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
    @State private var player1Name: String = "Roberto Abad"
    @State private var player1email: String = "invitado@invitado.com"
    @State private var cameraShoot: Image?
    @Environment(\.presentationMode) private var presentationMode
    public var onExit: () -> Void = { }
    init(onExit: @escaping (() -> Void)) {
        self.viewModel = LoginViewModel()
        viewModel.startLogin(modelContext)
        self.onExit = onExit
    }
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .center) {
                    exitButton
                    Spacer()
                    if viewModel.userSession {
                        loggedUserView
                        signOffLink
                    } else {
                        createUser
                        loginWithSocial
                    }
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .sheet(isPresented: $cameraManager.showImagePicker) {
            ImagePicker(image: $cameraManager.image, isPresented: $cameraManager.showImagePicker)
        }
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
                    .frame(width: 120, height: 120)
                    .padding(30)
                    .background(Color.green)
                    .clipShape(Circle())
                    .padding(10)
                    .background(LinearGradient(colors: [.blue, .white, .blue], startPoint: .bottomLeading, endPoint: .top))
                    .clipShape(Circle())
                
            }
            Text("Player name:")
            Text(viewModel.player?.name ?? "N/A").bold().padding(.bottom)
            Text("account email:")
            Text(viewModel.player?.email ?? "N/A").bold()
        }
        .padding()
    }
    var createUser: some View {
        VStack(alignment: .center) {
            Text("Who is the player 1?")
                .font(.title)
                .padding(.bottom, 20)
            Text("Enter your name:")
            TextField("Player 1 name", text: $player1Name)
                .padding(.bottom, 15)
            Text("Enter your email")
            TextField("email", text: $player1email)
            if !player1Name.isEmpty {
                takeAPictureView
            }
        }
        .padding(.horizontal, 30)
    }
    var takeAPictureView: some View {
        VStack {
            Text("Toma una foto del jugador")
            if let image = cameraManager.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
            }
            Button(action: {
                //TAKE A PICTURe
                cameraManager.checkCameraPermission(completion: { cameraPermisison in
                    if cameraPermisison {
                        cameraManager.openCamera()
                    }
                })
                
            }, label: {
                HStack {
                    Image(systemName: "camera.fill")
                        .resizable()
                        .frame(width: 18, height: 18)
                    Text(cameraManager.image == nil ? "Take a picture!":"Retake picture!")
                }
                .foregroundStyle(Color.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(15)
            })
            Button(action: {
                SessionManager.shared.signIn(modelContext, user: PlayerUser(id: UUID().uuidString,
                                                              name: $player1Name.wrappedValue,
                                                              email: $player1email.wrappedValue,
                                                              password: "dataPassword",
                                                              picture: cameraManager.image?.pngData()))
            }, label: {
                HStack {
                    Image(systemName: "person.fill.badge.plus")
                        .resizable()
                        .frame(width: 18, height: 18)
                    Text("Create user account!")
                }
                .foregroundStyle(Color.white)
                .padding()
                .background(Color.green)
                .cornerRadius(15)
            })
        }
    }
    var loginWithSocial: some View {
        VStack {
            Text("Or get login by using one of these")
            HStack {
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
                .padding(1)
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
            googleSignInButton
        }
        .padding(.top, 150)
    }
    var signOffLink: some View {
        Button(action: {
            viewModel.signOff(modelContext)
        }, label: {
            HStack {
                Image(systemName: "person.crop.circle.badge.xmark")
                Text("Sign Off")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color.red)
            .cornerRadius(20)
        })
    }
    var googleSignInButton: some View {
        VStack {
            HStack {
                GoogleSignInButton(action: viewModel.handleGoogleSignIn)
                Spacer()
            }
            .clipShape(Circle())
        }
    }
}

#Preview {
    LoginView(onExit: {})
}
