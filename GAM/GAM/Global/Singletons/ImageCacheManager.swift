//
//  ImageCacheManager.swift
//  GAM
//
//  Created by Jungbin on 2023/06/30.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
