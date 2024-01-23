//
//  SetPortfolioRequestDTO.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/8/24.
//

import Foundation

struct SetMyPortfolioRequestDTO: Encodable {
    let workId: Int
    
    init(workId: Int) {
        self.workId = workId
    }
}
