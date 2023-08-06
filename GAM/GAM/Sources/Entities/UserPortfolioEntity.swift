//
//  UserPortfolioEntity.swift
//  GAM
//
//  Created by Jungbin on 2023/07/26.
//

import Foundation

struct UserPortfolioEntity: Hashable {
    let id: Int
    let behanceURL: String
    let instagramURL: String
    let notionURL: String
    let projects: [ProjectEntity]
    
    static func == (lhs: UserPortfolioEntity, rhs: UserPortfolioEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
