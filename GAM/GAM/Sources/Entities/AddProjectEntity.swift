//
//  AddProjectEntity.swift
//  GAM
//
//  Created by Jungbin on 2023/08/22.
//

import Foundation
import UIKit.UIImage

struct AddProjectEntity: Hashable {
    let image: UIImage
    let title: String
    let detail: String
    
    init(image: UIImage, title: String, detail: String) {
        self.image = image.resizedToGamSize()
        self.title = title
        self.detail = detail
    }
}
