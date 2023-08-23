//
//  SignUpRequestDTO.swift
//  GAM
//
//  Created by Jungbin on 2023/08/23.
//

import Foundation

struct SignUpRequestDTO: Encodable {
    let tags: [Int]
    let username: String
    let info: String
}
