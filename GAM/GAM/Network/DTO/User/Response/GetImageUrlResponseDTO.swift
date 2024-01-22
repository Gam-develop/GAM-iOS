//
//  GetImageUrlResponseDTO.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/9/24.
//

import Foundation

struct GetImageUrlResponseDTO: Decodable {
    let preSignedUrl: String
    let fileName: String
}
