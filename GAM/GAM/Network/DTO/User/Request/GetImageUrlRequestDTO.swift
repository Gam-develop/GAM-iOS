//
//  GetImageUrlRequestDTO.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/9/24.
//

import Foundation

struct GetImageUrlRequestDTO: Encodable {
    let imageName: String
    
    init(imageName: String) {
        self.imageName = imageName
    }
}
