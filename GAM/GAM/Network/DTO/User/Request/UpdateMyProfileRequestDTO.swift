//
//  UpdateMyProfileRequestDTO.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/13/24.
//

import Foundation

struct UpdateMyProfileRequestDTO: Encodable {
    let userInfo: String
    let userDetail: String
    let email: String
    let tags: [Int]
    
    init(userInfo: String, userDetail: String, email: String, tags: [Int]) {
        self.userInfo = userInfo
        self.userDetail = userDetail
        self.email = email
        self.tags = tags
    }
}
