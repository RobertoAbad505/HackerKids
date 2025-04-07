//
//  SwiftDataManager.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/7/25.
//
import SwiftData
import Foundation

final class SwiftDataManager {
    static let shared: SwiftDataManager = .init()
    private init() {}
    
    func fetchOrCreate<T: PersistentModel>(_ modelContext: ModelContext,
                                           defaultValue: @autoclosure () -> T) -> T {
        let fetchDescriptor = FetchDescriptor<T>()
        
        do {
            if let existingObject = try modelContext.fetch(fetchDescriptor).first {
                return existingObject  // Si hay datos, retorna el primero
            } else {
                let newObject = defaultValue()
                modelContext.insert(newObject)
                try modelContext.save()
                return newObject
            }
        } catch {
            fatalError("Error al hacer fetch o crear \(T.self): \(error)")
        }
    }
    func create<T: PersistentModel>(_ modelContext: ModelContext,
                                    _ value: T) -> T {
        modelContext.insert(value)
        try! modelContext.save()
        return value
    }
    func delete<T: PersistentModel>(_ modelContext: ModelContext, _ value: T) {
        modelContext.delete(value)
        try! modelContext.save()
    }
}
