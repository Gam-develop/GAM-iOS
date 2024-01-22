//
//  UploadImageRequestDTO.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/10/24.
//

import UIKit

struct UploadImageRequestDTO {
    let uploadUrl: String
    let imageData: UIImage
    
    init(uploadUrl: String, image: UIImage) {
        self.uploadUrl = uploadUrl
        self.imageData = image
    }
}
