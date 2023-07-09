//
//  PopularDesignerEntity.swift
//  GAM
//
//  Created by Jungbin on 2023/07/09.
//

import UIKit

struct PopularDesignerEntity {
    let id: Int
    let thumbnailImageURL: String
    let name: String
    let tags: [TagEntity]
    var isScrap: Bool
    var visibilityCount: Int
    
    init(id: Int, thumbnailImageURL: String, name: String, tags: [Int], isScrap: Bool, visibilityCount: Int) {
        self.id = id
        self.thumbnailImageURL = thumbnailImageURL
        self.name = name
        self.tags = Tag.shared.mapTags(tags)
        self.isScrap = isScrap
        self.visibilityCount = visibilityCount
    }
}
