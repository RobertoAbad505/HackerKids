//
//  ChatWithBTFriendView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 3/28/25.
//

import SwiftUI

struct ChatWithBTFriendView: View {
    @ObservedObject var viewModel: ChatBTFriendViewModel = .init()
    @State var currentMessage: String = ""
    @State var writeAMessage: String = ""

    var body: some View {
        VStack {
            Text("Bluetooth Chat!")
                .font(.title)
                .padding(.bottom, 15)
            chatLog
            HStack {
                TextField("Escriba un mensaje", text: $viewModel.writeAMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: {
                    viewModel.sendMessage()
                }, label: {
                    Image(systemName: "chevron.forward")
                })
                .padding(.trailing, 10)
                .background(Color.white)
            }
            .background(Color.white)
            
            Spacer()
        }
        .padding()
        .onAppear {
//            viewModel.startChat()
        }
    }
    var chatLog: some View {
        ScrollViewReader { proxy in
            ScrollView {
                listado
            }
            .onChange(of: viewModel.receivedMessages) { _ in
                // Desplaza el scroll al último mensaje
                if let lastIndex = viewModel.receivedMessages.indices.last {
                    withAnimation {
                        proxy.scrollTo(lastIndex, anchor: .bottom)
                    }
                }
            }
        }
    }
    var listado: some View {
        VStack {
            Spacer()
            ForEach(Array(viewModel.receivedMessages.enumerated()), id: \.offset) { index, message in
//                let message = viewModel.receivedMessages[index]
                HStack {
                    if message.sender == .tx {
                        Spacer()
                    }
                    VStack(alignment: .leading) {
                        /*Text("\(message.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")*/
                        Text(message.timestamp)
                            .font(.subheadline)
                        Text(message.text)
                            .font(.body)
                    }
                    .fontWeight(.bold)
                    .padding(10)
                    .background(message.sender == .tx ? Color.green : Color.blue)
                    .cornerRadius(10)
                    .foregroundStyle(.white)
                    if message.sender == .rx {
                        Spacer()
                    }
                }
                .padding()
                .id(index)
            }
        }
    }
    var btControls: some View {
        HStack {
            Button(action: {
                viewModel.startChat()
            }, label: {
                HStack {
                    Image(systemName: "antenna.radiowaves.left.and.right.circle.fill")
                    Text("Start presence!")
                }
            })
            .foregroundStyle(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            Button(action: {
//                viewModel.stopBtPresence()
            }, label: {
                HStack {
                    Image(systemName: "antenna.radiowaves.left.and.right.slash.circle.fill")
                    Text("Stop presence!")
                }
            })
            .foregroundStyle(.white)
            .padding()
            .background(Color.gray)
            .cornerRadius(10)
        }
    }
}

#Preview {
    ChatWithBTFriendView()
}
