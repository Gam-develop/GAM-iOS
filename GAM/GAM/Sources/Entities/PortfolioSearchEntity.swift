//
//  PortfolioSearchEntity.swift
//  GAM
//
//  Created by Jungbin on 2023/07/24.
//

import UIKit

struct PortfolioSearchEntity: Hashable {
    let id: Int
    let thumbnailImageURL: String
    let title: String
    let author: String
    var visibilityCount: Int
    
    init(id: Int, thumbnailImageURL: String, title: String, author: String, visibilityCount: Int) {
        self.id = id
        self.thumbnailImageURL = thumbnailImageURL
        self.title = title
        self.author = author
        self.visibilityCount = visibilityCount
    }
}
