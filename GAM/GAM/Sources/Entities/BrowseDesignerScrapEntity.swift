//
//  BrowseDesignerScrapEntity.swift
//  GAM
//
//  Created by Jungbin on 2023/07/24.
//

import Foundation

struct BrowseDesignerScrapEntity {
    let id: Int
    let thumbnailImageURL: String
    let name: String
    var isScrap: Bool
    
    init(id: Int, thumbnailImageURL: String, name: String, isScrap: Bool) {
        self.id = id
        self.thumbnailImageURL = thumbnailImageURL
        self.name = name
        self.isScrap = isScrap
    }
}
