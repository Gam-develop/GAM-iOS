//
//  Tag.swift
//  GAM
//
//  Created by Jungbin on 2023/07/07.
//

import Foundation

final class Tag {
    static let shared = Tag()
    
    private init() { }
    
    let tags: [TagEntity] = [
        .init(id: 1, name: "UI/UX 디자인"),
        .init(id: 2, name: "BI/BX 디자인"),
        .init(id: 3, name: "산업 디자인"),
        .init(id: 4, name: "3D 디자인"),
        .init(id: 5, name: "그래픽 디자인"),
        .init(id: 6, name: "패키지 디자인"),
        .init(id: 7, name: "영상, 모션 디자인"),
        .init(id: 8, name: "일러스트"),
        .init(id: 9, name: "편집 디자인"),
        .init(id: 10, name: "패션 디자인"),
        .init(id: 11, name: "공간 디자인"),
        .init(id: 12, name: "캐릭터 디자인")
    ]
}

struct TagEntity {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
