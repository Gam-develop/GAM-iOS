//
//  TagEntity.swift
//  GAM
//
//  Created by Jungbin on 2023/07/09.
//

import Foundation

struct TagEntity {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    public static func == (lhs: TagEntity, rhs: TagEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
