//
//  PortfolioSearchEntity.swift
//  GAM
//
//  Created by Jungbin on 2023/07/24.
//

import UIKit

struct PortfolioSearchEntity: Hashable {
    let userId: Int
    let thumbnailImageURL: String
    let title: String
    let author: String
    var visibilityCount: Int
}
