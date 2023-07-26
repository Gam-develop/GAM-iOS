//
//  BrowseDesignerEntity.swift
//  GAM
//
//  Created by Jungbin on 2023/07/17.
//

import Foundation

struct BrowseDesignerEntity {
    let id: Int
    let thumbnailImageURL: String
    let majorWorkTitle: String
    let name: String
    let info: String
    let tags: [TagEntity]
    var isScrap: Bool
    var visibilityCount: Int
    
    init(id: Int, thumbnailImageURL: String, majorWorkTitle: String, name: String, info: String, tags: [Int], isScrap: Bool, visibilityCount: Int) {
        self.id = id
        self.thumbnailImageURL = thumbnailImageURL
        self.majorWorkTitle = majorWorkTitle
        self.name = name
        self.info = info
        self.tags = Tag.shared.mapTags(tags)
        self.isScrap = isScrap
        self.visibilityCount = visibilityCount
    }
}
