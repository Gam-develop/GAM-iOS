//
//  CreatePortfolioRequestDTO.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/8/24.
//

import Foundation

struct CreatePortfolioRequestDTO: Encodable {
    let image: String
    let title: String
    let detail: String
    
    init(image: String, title: String, detail: String) {
        self.image = image
        self.title = title
        self.detail = detail
    }
}
