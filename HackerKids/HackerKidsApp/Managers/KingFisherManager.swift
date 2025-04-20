//
//  KingFisherManager.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/19/25.
//

import Foundation
import Kingfisher
import SwiftUI

final class ImageManager {
    static let shared = ImageManager()
    
    private let imageCache = ImageCache.default
    private let downloader = KingfisherManager.shared
    
    private init() {
        //configuracion opcional de cache
        imageCache.diskStorage.config.expiration = .days(30)
        imageCache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024
    }
    
    //Pre cachear lista de imagenes conocidas
    func prefetchImages(from urls: [URL]) {
        let prefetcher = ImagePrefetcher(urls: urls)
        prefetcher.start()
    }
    
    //descarga o lee una imagen del cache
    func loadImage(from url: URL, completion: @escaping (Result<KFCrossPlatformImage, KingfisherError>) -> Void) {
        downloader.retrieveImage(
            with: url,
            options: [
                .cacheOriginalImage,
                .diskCacheExpiration(.days(30))
            ],
            completionHandler: { result in
                completion(result.map(\.image))
            }
        )
    }
    //limpiar todo el cache ||for debug|| logout optional
    func clearCache() {
        imageCache.clearMemoryCache()
        imageCache.clearDiskCache {
            print("Disk cache cleared.")
        }
    }
}
