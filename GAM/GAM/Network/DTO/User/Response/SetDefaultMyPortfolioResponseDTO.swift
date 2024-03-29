//
//  SetDefaultMyPortfolioResponseDTO.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/8/24.
//

import Foundation

struct SetDefaultMyPortfolioResponseDTO: Decodable {
    let workID: Int

    enum CodingKeys: String, CodingKey {
        case workID = "workId"
    }
}
