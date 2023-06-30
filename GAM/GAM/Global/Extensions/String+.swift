//
//  String+.swift
//  GAM
//
//  Created by Jungbin on 2023/06/30.
//

import Foundation
import UIKit.UIImage

extension String {
    func getImage(completion: @escaping (UIImage) -> ()){
        let cacheKey = NSString(string: self)
        
        /// 해당 Key에 캐시 이미지가 저장되어 있으면 이미지 사용
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            completion(cachedImage)
        }
        
        if let requestURL = URL(string: self) {
            let request = URLRequest(url: requestURL)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data,
                   let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300,
                   let image = UIImage(data: data) {
                    
                    /// 다운받은 이미지를 캐시에 저장
                    ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                    completion(image)
                }
            }.resume()
        }
    }
}
