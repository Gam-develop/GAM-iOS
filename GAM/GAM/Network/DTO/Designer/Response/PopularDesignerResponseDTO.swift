//
//  PopularDesignerResponseDTO.swift
//  GAM
//
//  Created by Jungbin on 2023/08/24.
//

import Foundation

// MARK: - PopularDesignerDTOElement
struct PopularDesignerResponseDTOElement: Codable {
    let userInfo: UserInfoDTO
    let workInfo: WorkInfoDTO

    enum CodingKeys: String, CodingKey {
        case userInfo = "UserInfo"
        case workInfo = "WorkInfo"
    }
}

// MARK: - UserInfo
struct UserInfoDTO: Codable {
    let userID: Int
    let userTag: [Int]
    let userName: String
    let viewCount: Int
    let userDetail: String
    let designerScrap: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case userTag = "userTag"
        case userName = "userName"
        case viewCount = "viewCount"
        case userDetail = "userDetail"
        case designerScrap = "designerScrap"
    }
}

// MARK: - WorkInfo
struct WorkInfoDTO: Codable {
    let workID: Int
    let workTitle: String
    let photoURL: String

    enum CodingKeys: String, CodingKey {
        case workID = "workId"
        case workTitle = "workTitle"
        case photoURL = "photoUrl"
    }
}

typealias PopularDesignerResponseDTO = [PopularDesignerResponseDTOElement]

extension PopularDesignerResponseDTO {
    func toPopularDesignerEntity() -> [PopularDesignerEntity] {
        var popularDesignerEntity: [PopularDesignerEntity] = []
        
        _ = self.map({
            popularDesignerEntity.append(
                PopularDesignerEntity(
                    id: $0.userInfo.userID,
                    thumbnailImageURL: $0.workInfo.photoURL,
                    name: $0.userInfo.userName,
                    tags: $0.userInfo.userTag,
                    isScrap: $0.userInfo.designerScrap,
                    visibilityCount: $0.userInfo.viewCount
                )
            )
        })
        
        return popularDesignerEntity
    }
}
