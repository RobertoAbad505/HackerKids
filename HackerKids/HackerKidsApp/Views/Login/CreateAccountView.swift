//
//  CreateAccountView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/8/25.
//
import SwiftData
import SwiftUI

struct CreateAccountView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var cameraManager: CameraManager = CameraManager()
    @ObservedObject var viewModel: LoginViewModel
    @State private var player1Name: String = "Roberto Abad"
    @State private var player1email: String = "roberto.rmzabad@gmail.com"
    @State private var cameraShoot: Image?
    @Environment(\.presentationMode) private var presentationMode
    
    init(_ viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        VStack(alignment: .center,spacing: 20) {
            Text("Who is player 1?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .rotation3DEffect(
                    .degrees(-15), // Ángulo de rotación
                    axis: (x: 1, y: 1, z: 0)
                )
                .foregroundColor(.purple)
                .shadow(color: .gray, radius: 10, x: 5, y: 5) // Sombra para mayor profundidad
            Text("Enter your name:")
            TextField("Player 1 name", text: $player1Name)
                .padding(.bottom, 15)
            Text("Enter your email")
            TextField("email", text: $player1email)
                .padding(.horizontal)
            if !player1Name.isEmpty {
                takeAPictureView
            }
        }
        .padding(.horizontal, 30)
        .sheet(isPresented: $cameraManager.showImagePicker) {
            ImagePicker(image: $cameraManager.image, isPresented: $cameraManager.showImagePicker)
        }
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
//                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(cameraManager.image == nil ? "Take a picture!":"Retake picture!")
                }
                .foregroundStyle(Color.white)
            })
            .padding()
            .background(Color.blue)
            .cornerRadius(15)
            Button(action: {
                if cameraManager.image == nil {
//                    cameraManager.image = UIImage(systemName: "airplane.departure")!
                    cameraManager.image = UIImage(named: "gitIcon")!
                }
                viewModel.createUserAccount(modelContext, readNewAccountForm())
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
    func readNewAccountForm() -> PlayerUser {
        return PlayerUser(id: UUID().uuidString,
                          name: player1Name,
                          email: player1email,
                          picture: cameraManager.image?.pngData(),
                          signOnType: .account
        )
    }
}

#Preview {
    CreateAccountView(LoginViewModel())
}
