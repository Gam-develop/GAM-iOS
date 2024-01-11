//
//  UpdatePortfolioRequestDTO.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/12/24.
//

import Foundation

struct UpdatePortfolioRequestDTO: Encodable {
    let workId: Int
    let image: String
    let title: String
    let detail: String
    
    init(workId: Int, image: String, title: String, detail: String) {
        self.workId = workId
        self.image = image
        self.title = title
        self.detail = detail
    }
}
