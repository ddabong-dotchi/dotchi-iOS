//
//  ImageCacheManager.swift
//  DOTCHI
//
//  Created by Jungbin on 6/27/24.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
