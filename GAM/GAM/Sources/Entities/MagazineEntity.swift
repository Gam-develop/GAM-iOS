//
//  MagazineEntity.swift
//  GAM
//
//  Created by Jungbin on 2023/07/09.
//

import UIKit

struct MagazineEntity: Hashable {
    let id: Int
    let thumbnailImageURL: String
    let title: String
    let author: String
    var isScrap: Bool
    let url: String
    var visibilityCount: Int
    
    init(id: Int, thumbnailImageURL: String, title: String, author: String, isScrap: Bool, url: String, visibilityCount: Int) {
        self.id = id
        self.thumbnailImageURL = thumbnailImageURL
        self.title = title
        self.author = author
        self.isScrap = isScrap
        self.url = url
        self.visibilityCount = visibilityCount
    }
}
