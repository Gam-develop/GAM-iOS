//
//  AddProjectEntity.swift
//  GAM
//
//  Created by Jungbin on 2023/08/22.
//

import Foundation

struct AddProjectEntity: Hashable {
    let image: String
    let title: String
    let detail: String
    
    init(image: String, title: String, detail: String) {
        self.image = image
        self.title = title
        self.detail = detail
    }
}
