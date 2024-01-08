//
//  PopularDesignerResponseDTO.swift
//  GAM
//
//  Created by Jungbin on 2023/08/24.
//

import Foundation

// MARK: - PopularDesignerResponseDTO
struct PopularDesignerResponseDTOElement: Codable {
    let userID: Int
    let userTag: [Int]
    let userName: String
    let viewCount: Int
    let userDetail: String
    let designerScrap: Bool
    let thumbnailImageURL: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case userTag = "userTag"
        case userName = "userName"
        case viewCount = "viewCount"
        case userDetail = "userDetail"
        case designerScrap = "designerScrap"
        case thumbnailImageURL = "userWorkThumbNail"
    }
}

// MARK: - WorkInfo
//struct WorkInfoDTO: Codable {
//    let workID: Int
//    let workTitle: String
//    let photoURL: String
//
//    enum CodingKeys: String, CodingKey {
//        case workID = "workId"
//        case workTitle = "workTitle"
//        case photoURL = "photoUrl"
//    }
//}

typealias PopularDesignerResponseDTO = [PopularDesignerResponseDTOElement]

extension PopularDesignerResponseDTO {
    func toPopularDesignerEntity() -> [PopularDesignerEntity] {
        var popularDesignerEntity: [PopularDesignerEntity] = []
        
        _ = self.map({
            popularDesignerEntity.append(
                PopularDesignerEntity(
                    id: $0.userID,
                    thumbnailImageURL: $0.thumbnailImageURL,
                    name: $0.userName,
                    tags: $0.userTag,
                    isScrap: $0.designerScrap,
                    visibilityCount: $0.viewCount
                )
            )
        })
        
        return popularDesignerEntity
    }
}
