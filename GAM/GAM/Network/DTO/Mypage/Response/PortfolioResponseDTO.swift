//
//  PortfolioResponseDTO.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/8/24.
//

import Foundation

struct PortfolioResponseDTO: Decodable {
    let behanceLink: String
    let instagramLink: String
    let notionLink: String
    let works: [Work]
}

struct Work: Codable {
    let workId: Int
    let workThumbNail, workTitle, workDetail: String
}

extension PortfolioResponseDTO {
    
    func toUserPortfolioEntity() -> UserPortfolioEntity {
        let projects = works.map { work in
            ProjectEntity(id: work.workId, thumbnailImageURL: work.workThumbNail, title: work.workTitle, detail: work.workDetail)
        }

        return UserPortfolioEntity(id: 0, behanceURL: behanceLink, instagramURL: instagramLink, notionURL: notionLink, projects: projects)
    }
}
