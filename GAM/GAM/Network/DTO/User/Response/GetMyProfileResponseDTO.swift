//
//  GetMyProfileResponseDTO.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/12/24.
//

import Foundation

struct GetMyProfileResponseDTO: Decodable {
    let userId: Int
    let userName, info, detail, email: String
    let userTag: [Int]
}


extension GetMyProfileResponseDTO {
    func toUserProfileEntity() -> UserProfileEntity {
        return UserProfileEntity(userID: userId,
                                 name: userName,
                                 isScrap: false,
                                 info: info,
                                 infoDetail: detail,
                                 tags: userTag,
                                 email: email)
    }
}
