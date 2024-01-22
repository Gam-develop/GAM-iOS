//
//  SearchDesignerResponseDTO.swift
//  GAM
//
//  Created by Jungbin on 1/16/24.
//

import Foundation

// MARK: - SearchDesignerResponseDTOElement
struct SearchDesignerResponseDTOElement: Decodable {
    let thumbNail, title, userName: String
    let userID, viewCount: Int

    enum CodingKeys: String, CodingKey {
        case thumbNail, title, userName, viewCount
        case userID = "userId"
    }
}

typealias SearchDesignerResponseDTO = [SearchDesignerResponseDTOElement]

extension SearchDesignerResponseDTO {
    func toPortfolioSearchEntity() -> [PortfolioSearchEntity] {
        return self.map { designerResponse in
            PortfolioSearchEntity(
                userId: designerResponse.userID,
                thumbnailImageURL: designerResponse.thumbNail,
                title: designerResponse.title,
                author: designerResponse.userName,
                visibilityCount: designerResponse.viewCount
            )
        }
    }
}
