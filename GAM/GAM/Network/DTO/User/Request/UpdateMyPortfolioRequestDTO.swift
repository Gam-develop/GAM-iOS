//
//  UpdatePortfolioRequestDTO.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/12/24.
//

import Foundation

struct UpdateMyPortfolioRequestDTO: Encodable {
    let workId: Int
    let image: String
    let title: String
    let detail: String
}
