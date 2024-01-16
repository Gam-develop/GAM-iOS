//
//  GetBrowseDesignerResponseDTO.swift
//  GAM
//
//  Created by Jungbin on 1/16/24.
//

import Foundation

// MARK: - GetBrowseDesignerResponseDTOElement

struct GetBrowseDesignerResponseDTOElement: Decodable {
    let userInfo: UserInfo
    let workInfo: WorkInfo

    enum CodingKeys: String, CodingKey {
        case userInfo = "UserInfo"
        case workInfo = "WorkInfo"
    }
    
    // MARK: - UserInfo
    
    struct UserInfo: Decodable {
        let userID: Int
        let userTag: [Int]
        let userName: String
        let viewCount: Int
        let userDetail: String
        let designerScrap: Bool

        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case userTag, userName, viewCount, userDetail, designerScrap
        }
    }
    
    // MARK: - WorkInfo
    
    struct WorkInfo: Decodable {
        let workID: Int
        let workTitle: String
        let photoURL: String

        enum CodingKeys: String, CodingKey {
            case workID = "workId"
            case photoURL = "photoUrl"
            case workTitle
        }
    }
}

typealias GetBrowseDesignerResponseDTO = [GetBrowseDesignerResponseDTOElement]

extension GetBrowseDesignerResponseDTO {
    func toBrowseDesignerEntity() -> [BrowseDesignerEntity] {
        return self.map { designerResponse in
            BrowseDesignerEntity(
                id: designerResponse.userInfo.userID,
                thumbnailImageURL: designerResponse.workInfo.photoURL,
                majorProjectTitle: designerResponse.workInfo.workTitle,
                name: designerResponse.userInfo.userName,
                info: designerResponse.userInfo.userDetail,
                tags: designerResponse.userInfo.userTag,
                isScrap: designerResponse.userInfo.designerScrap,
                visibilityCount: designerResponse.userInfo.viewCount
            )
        }
    }
}
