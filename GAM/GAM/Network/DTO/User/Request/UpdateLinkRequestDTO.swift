//
//  UpdateLinkRequestDTO.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/10/24.
//

import Foundation

struct UpdateLinkRequestDTO: Encodable {
    let link: String
    
    init(link: String) {
        self.link = link
    }
}
