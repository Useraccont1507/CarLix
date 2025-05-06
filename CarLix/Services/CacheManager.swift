//
//  CacheManager.swift
//  CarLix
//
//  Created by Illia Verezei on 06.05.2025.
//

import Foundation
import UIKit

final class CacheManager {
    static let shared = CacheManager()
    private init() {}

    private let cache = NSCache<NSString, UIImage>()

    func image(forKey key: String) -> UIImage? {
        if let image = cache.object(forKey: key as NSString) {
            print("✅ Cache HIT for key: \(key)")
            return image
        } else {
            print("❌ Cache MISS for key: \(key)")
            return nil
        }
    }

    func insertImage(_ image: UIImage?, forKey key: String) {
        guard let image = image else { return }
        cache.setObject(image, forKey: key as NSString)
        print("🟢 Image cached for key: \(key)")
    }
}
