//
//  ChatBTFriendViewModel.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 3/28/25.
//
import Combine
import Foundation
import CoreBluetooth

class ChatBTFriendViewModel: ObservableObject {
    let btManager: BluetoothManager = BluetoothManager()
    @Published var devices: [CBPeripheral] = []
    @Published var isBluetoothReady = false
    @Published var currentMessage: String = ""
    @Published var writeAMessage: String = ""
    @Published var receivedMessages: [MessageBT] = []
    private var cancellables = Set<AnyCancellable>()

    init () {
        //connect this viewModel to BT manager
        btManager.$messages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.receivedMessages = value
            }
            .store(in: &cancellables)
        // Vincular el estado de Bluetooth al ViewModel
        btManager.$isConnected
            .receive(on: DispatchQueue.main)
            .assign(to: &$isBluetoothReady)
    }
    public func startChat() {
        btManager.startBluetooth()
    }
    public func sendMessage() {
        if writeAMessage.count > 0 {
            self.btManager.sendMessage(self.writeAMessage)
            writeAMessage = ""
        }
    }
}
