//
//  BluetoothManager.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 3/28/25.
//
import Foundation
import CoreBluetooth
import Combine

class BluetoothManager: NSObject, ObservableObject {
    
    // Propiedades Bluetooth
    private var centralManager: CBCentralManager?
    
    private var peripheralManager: CBPeripheralManager?
    private var characteristic: CBMutableCharacteristic?
    
    @Published var devices: [CBPeripheral] = []
    
    @Published var messages: [MessageBT] = []
    @Published var isConnected = false
    
    override init() {
//        super.init()
//        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    //Escanear dispositivos cercanos
    func startScanning() {
        devices.removeAll()
        centralManager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        print("🔍 Escaneando dispositivos...")
    }
    
    // Conectar con el dispositivo seleccionado
//    func connect(to peripheral: CBPeripheral) {
//        self.peripheral = peripheral
//        self.peripheral?.delegate = self
//        centralManager?.connect(peripheral, options: nil)
//        print("🔗 Conectando a: \(peripheral.name ?? "Sin nombre")")
//    }
    
    // Iniciar Bluetooth en un hilo secundario
    func startBluetooth() {
//        DispatchQueue.global(qos: .background).async {
//            self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
//            
//            // Esperar a que Bluetooth esté encendido
//            while self.peripheralManager?.state != .poweredOn {
//                sleep(1)
//            }
//            
//            DispatchQueue.main.async {
//                self.isBluetoothReady = true
//                self.setupService()
//            }
//        }
    }
    
    // Configurar el servicio y la característica
    private func setupService() {
        let serviceUUID = CBUUID(string: "1234")
        let characteristicUUID = CBUUID(string: "5678")
        
        characteristic = CBMutableCharacteristic(
            type: characteristicUUID,
            properties: [.read, .write, .writeWithoutResponse],
            value: nil,
            permissions: [.readable, .writeable]
        )
        
        let service = CBMutableService(type: serviceUUID, primary: true)
        service.characteristics = [characteristic!]
        
        peripheralManager?.add(service)
        
        startAdvertising()
    }
    
    // Publicitar la conexión Bluetooth
    private func startAdvertising() {
        peripheralManager?.startAdvertising([
            CBAdvertisementDataLocalNameKey: "BLE Chat",
            CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: "1234")]
        ])
        print("🔵 Advertising started...")
    }
    
    // 🟢 Escribir datos a la característica
    func sendMessage(_ message: String) {
        guard let characteristic = characteristic else { return }
        
        let data = message.data(using: .utf8) ?? Data()
        
        // Enviar datos a los suscriptores
        let isSuccess = peripheralManager?.updateValue(data, for: characteristic, onSubscribedCentrals: nil) ?? false
        
        if isSuccess {
            print("✅ Mensaje enviado: \(message)")
            
            // Agregar al historial
            let msg = MessageBT(text: message, sender: .tx)
            DispatchQueue.main.async {
                self.messages.append(msg)
            }
        } else {
            print("❌ No se pudo enviar el mensaje")
        }
    }
    
    // 🔵 Leer datos entrantes
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            if let value = request.value, let message = String(data: value, encoding: .utf8) {
                print("📥 Mensaje recibido: \(message)")
                
                // Agregar al historial
                let receivedMessage = MessageBT(text: message, sender: .rx)
                DispatchQueue.main.async {
                    self.messages.append(receivedMessage)
                }
            }
            
            peripheralManager?.respond(to: request, withResult: .success)
        }
    }
    
    // Manejo del estado Bluetooth
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
//        DispatchQueue.main.async {
//            self.isBluetoothReady = peripheral.state == .poweredOn
//        }
    }
}

extension BluetoothManager: CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // Estado Bluetooth
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        } else {
            print("❌ Bluetooth no disponible")
        }
    }
    
    // Detectar dispositivos cercanos
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !devices.contains(where: { $0.identifier == peripheral.identifier }) {
            devices.append(peripheral)
            print("🟢 Encontrado: \(peripheral.name ?? "Sin nombre")")
        }
    }
    
    // Conexión exitosa
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("✅ Conectado a: \(peripheral.name ?? "Sin nombre")")
        isConnected = true
        peripheral.discoverServices(nil)
    }
    
    // Descubrir servicios y características
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    // Descubrir características
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
//            if characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) {
//                messageCharacteristic = characteristic
//                print("🟡 Característica lista para escribir")
//            }
            
            if characteristic.properties.contains(.read) || characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    // Leer mensajes entrantes
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value, let message = String(data: data, encoding: .utf8) {
            print("📥 Mensaje recibido: \(message)")
            
            let receivedMessage = MessageBT(text: message, sender: .rx)
            DispatchQueue.main.async {
                self.messages.append(receivedMessage)
            }
        }
    }
    
    // Desconexión
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("🔴 Desconectado de: \(peripheral.name ?? "Sin nombre")")
        isConnected = false
        startScanning()
    }
}
