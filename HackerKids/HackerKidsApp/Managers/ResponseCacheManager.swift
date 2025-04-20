//
//  ResponseCacheManager.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/19/25.
//

import Foundation

final class ResponseCacheManager {
    static let shared = ResponseCacheManager()
    
    private let memoryCache = NSCache<NSString, NSData>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        self.cacheDirectory = urls[0].appendingPathComponent("HackerKidsResponseCache")
        
        //crear directorio si no existe
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    private func cacheFileURL(for key: String) -> URL {
        let fileName = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? UUID().uuidString
        return cacheDirectory.appendingPathComponent(fileName)
    }
    func get(forKey key: String) -> Data? {
        //primero intentar obtener la data desde memoria
        if let memoryData = memoryCache.object(forKey: key as NSString) {
            return memoryData as Data
        }
        
        //si no esta en memoria, intentar desde disco
        let fileURL = cacheFileURL(for: key)
        guard let diskData = try? Data(contentsOf: fileURL) else { return nil }//obtener la data
        
        //guardar en memoria para la proxima
        memoryCache.setObject(diskData as NSData, forKey: key as NSString)
        return diskData
    }
    func set(_ data: Data, forKey key: String) {
        memoryCache.setObject(data as NSData, forKey: key as NSString)
        
        let fileURL = cacheFileURL(for: key)
        try? data.write(to: fileURL)
    }
    func remove(forKey key: String) {
        memoryCache.removeObject(forKey: key as NSString)
        let fileURL = cacheFileURL(for: key)
        try? fileManager.removeItem(at: fileURL)
    }
}
