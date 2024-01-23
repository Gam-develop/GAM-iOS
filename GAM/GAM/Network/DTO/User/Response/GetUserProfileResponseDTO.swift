//
//  GetUserProfileResponeDTO.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/18/24.
//

import Foundation

struct GetUserProfileResponseDTO: Decodable {
    let isScrap: Bool
    let userInfo: UserInfo

    enum CodingKeys: String, CodingKey {
        case isScrap = "designerScrap"
        case userInfo = "UserInfo"
    }
    
    struct UserInfo: Decodable {
        let userId: Int
        let userName, info, detail, email: String
        let userTag: [Int]
    }
}

extension GetUserProfileResponseDTO {
    func toUserProfileEntity() -> UserProfileEntity {
        return UserProfileEntity(userID: userInfo.userId,
                                 name: userInfo.userName,
                                 isScrap: isScrap,
                                 info: userInfo.info,
                                 infoDetail: userInfo.detail,
                                 tags: userInfo.userTag,
                                 email: userInfo.email)
    }
}
