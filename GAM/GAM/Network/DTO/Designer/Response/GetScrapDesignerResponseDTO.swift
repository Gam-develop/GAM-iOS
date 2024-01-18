//
//  GetScrapDesignerResponseDTO.swift
//  GAM
//
//  Created by Jungbin on 1/16/24.
//

import Foundation

struct GetScrapDesignerResponseDTOElement: Decodable {
    let userID: Int
    let userName: String
    let userThumbNail: String
    let userScrapID: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case userScrapID = "userScrapId"
        case userName, userThumbNail
    }
}

typealias GetScrapDesignerResponseDTO = [GetScrapDesignerResponseDTOElement]

extension GetScrapDesignerResponseDTO {
    func toBrowseDesignerScrapEntity() -> [BrowseDesignerScrapEntity] {
        return self.map { designerResponse in
            BrowseDesignerScrapEntity(
                userId: designerResponse.userID,
                thumbnailImageURL: designerResponse.userThumbNail,
                name: designerResponse.userName,
                isScrap: true
            )
        }
    }
}
