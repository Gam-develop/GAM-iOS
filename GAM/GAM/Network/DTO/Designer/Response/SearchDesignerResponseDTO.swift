//
//  SearchDesignerResponseDTO.swift
//  GAM
//
//  Created by Jungbin on 1/16/24.
//

import Foundation

// MARK: - SearchDesignerResponseDTOElement
struct SearchDesignerResponseDTOElement: Codable {
    let thumbNail, title, userName: String
    let userID, viewCount: Int

    enum CodingKeys: String, CodingKey {
        case thumbNail, title, userName
        case userID = "userId"
        case viewCount
    }
}

typealias SearchDesignerResponseDTO = [SearchDesignerResponseDTOElement]

extension SearchDesignerResponseDTO {
    func toPortfolioSearchEntity() -> [PortfolioSearchEntity] {
        return self.map { designerResponse in
            PortfolioSearchEntity(
                id: designerResponse.userID,
                thumbnailImageURL: designerResponse.thumbNail,
                title: designerResponse.title,
                author: designerResponse.userName,
                visibilityCount: designerResponse.viewCount
            )
        }
    }
}
