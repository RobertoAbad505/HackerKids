//
//  SwiftDataManager.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/7/25.
//
import SwiftData
import Foundation

import SwiftData

final class SwiftDataManager {
    static let shared = SwiftDataManager()
    
    private init() {} // No se necesita container aquí, el contexto se inyecta

    // MARK: - Create
    func insert<T: PersistentModel>(_ model: T, in context: ModelContext) throws {
        context.insert(model)
        try context.save()
    }

    func insertAsync<T: PersistentModel>(_ model: T, in context: ModelContext) async throws {
        context.insert(model)
        try await context.save()
    }

    // MARK: - Read
    func fetchAll<T: PersistentModel>(ofType type: T.Type, in context: ModelContext) throws -> [T] {
        let descriptor = FetchDescriptor<T>()
        return try context.fetch(descriptor)
    }

    func fetchLast<T: PersistentModel>(ofType type: T.Type, in context: ModelContext) throws -> T? {
        let descriptor = FetchDescriptor<T>(sortBy: [.init(\.persistentModelID, order: .reverse)])
        return try context.fetch(descriptor).first
    }

    // MARK: - Update
    func update<T: PersistentModel>(_ model: T, in context: ModelContext) throws {
        // Asumiendo que los cambios ya fueron hechos en el modelo
        try context.save()
    }

    func updateAsync<T: PersistentModel>(_ model: T, in context: ModelContext) async throws {
        try await context.save()
    }

    // MARK: - Delete
    func delete<T: PersistentModel>(_ model: T, in context: ModelContext) throws {
        context.delete(model)
        try context.save()
    }

    func deleteAsync<T: PersistentModel>(_ model: T, in context: ModelContext) async throws {
        context.delete(model)
        try await context.save()
    }
    func deleteAll<T: PersistentModel>(_ type: T.Type, in context: ModelContext) throws {
        let fetchDescriptor = FetchDescriptor<T>()
        if let results = try? context.fetch(fetchDescriptor) {
            for item in results {
                context.delete(item)
            }
            try context.save()
        }
    }
}

