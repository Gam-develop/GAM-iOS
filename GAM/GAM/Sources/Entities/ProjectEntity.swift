//
//  ProjectEntity.swift
//  GAM
//
//  Created by Jungbin on 2023/07/27.
//

import Foundation

struct ProjectEntity: Hashable {
    let id: Int
    let thumbnailImageURL: String
    let title: String
    let detail: String
    
    init(id: Int, thumbnailImageURL: String, title: String, detail: String) {
        self.id = id
        self.thumbnailImageURL = thumbnailImageURL
        self.title = title
        self.detail = detail
    }
}
