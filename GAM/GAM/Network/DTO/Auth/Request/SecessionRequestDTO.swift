//
//  SecessionRequestDTO.swift
//  GAM
//
//  Created by Juhyeon Byun on 2/13/24.
//

import Foundation

struct SecessionRequestDTO: Encodable {
    let deleteAccountReasons: [Int]
    let directInput: String?
}
