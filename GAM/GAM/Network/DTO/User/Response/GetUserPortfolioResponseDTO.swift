//
//  GetUserPortfolioResponseDTO.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/21/24.
//

import Foundation

struct GetUserPortfolioResponseDTO: Decodable {
    let isScraped: Bool
    let behanceLink, instagramLink, notionLink: String
    let works: [Work]
    
    struct Work: Codable {
        let workId: Int
        let workThumbNail, workTitle, workDetail: String
    }
}

extension GetUserPortfolioResponseDTO {
    
    var projects: [ProjectEntity] {
        return works.map { work in
            return ProjectEntity(id: work.workId, thumbnailImageURL: work.workThumbNail, title: work.workTitle, detail: work.workDetail)
        }
    }

    func toUserPortfolioEntity() -> UserPortfolioEntity {
        return UserPortfolioEntity(id: 0, behanceURL: behanceLink, instagramURL: instagramLink, notionURL: notionLink, projects: projects)
    }
}
