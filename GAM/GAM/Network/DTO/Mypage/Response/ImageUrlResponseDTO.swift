//
//  ImageUrlResponseDTO.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/9/24.
//

import Foundation

struct ImageUrlResponseDTO: Codable {
    let preSignedUrl: String
    let fileName: String
}
