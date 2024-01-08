//
//  PortfolioResponseDTO.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/8/24.
//

import Foundation

struct PortfolioResponseDTO: Codable {
    let behanceLink: String
    let instagramLink: String
    let notionLink: String
    let works: [Work]
}

struct Work: Codable {
    let workID: Int
    let workThumbNail, workTitle, workDetail: String

    enum CodingKeys: String, CodingKey {
        case workID = "workId"
        case workThumbNail, workTitle, workDetail
    }
}

extension PortfolioResponseDTO {
    
    func toUserPortfolioEntity() -> UserPortfolioEntity {
        let projects = works.map { work in
            ProjectEntity(id: 0, thumbnailImageURL: work.workThumbNail, title: work.workTitle, detail: work.workDetail)
        }

        return UserPortfolioEntity(id: 0, behanceURL: behanceLink, instagramURL: instagramLink, notionURL: notionLink, projects: projects)
    }
}
