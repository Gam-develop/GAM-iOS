//
//  BrowseDesignerEntity.swift
//  GAM
//
//  Created by Jungbin on 2023/07/17.
//

import Foundation

struct BrowseDesignerEntity {
    let userId: Int
    let thumbnailImageURL: String
    let majorProjectTitle: String
    let name: String
    let info: String
    let tags: [TagEntity]
    var isScrap: Bool
    var visibilityCount: Int
    
    init(userId: Int, thumbnailImageURL: String, majorProjectTitle: String, name: String, info: String, tags: [Int], isScrap: Bool, visibilityCount: Int) {
        self.userId = userId
        self.thumbnailImageURL = thumbnailImageURL
        self.majorProjectTitle = majorProjectTitle
        self.name = name
        self.info = info
        self.tags = Tag.shared.mapTags(tags)
        self.isScrap = isScrap
        self.visibilityCount = visibilityCount
    }
}
