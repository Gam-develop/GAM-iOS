//
//  UserProfileEntity.swift
//  GAM
//
//  Created by Jungbin on 2023/07/27.
//

import Foundation

struct UserProfileEntity {
    let userID: Int
    let name: String
    let isScrap: Bool
    let info: String
    let infoDetail: String
    let tags: [TagEntity]
    let email: String
    
    static func == (lhs: UserProfileEntity, rhs: UserProfileEntity) -> Bool {
        return lhs.userID == rhs.userID
    }
    
    init(userID: Int, name: String, isScrap: Bool, info: String, infoDetail: String, tags: [Int], email: String) {
        self.userID = userID
        self.name = name
        self.isScrap = isScrap
        self.info = info
        self.infoDetail = infoDetail
        self.tags = Tag.shared.mapTags(tags)
        self.email = email
    }
}
