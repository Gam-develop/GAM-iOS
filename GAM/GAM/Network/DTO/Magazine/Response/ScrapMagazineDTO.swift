//
//  ScrapMagazineDTO.swift
//  GAM
//
//  Created by Jungbin on 2023/09/02.
//

import Foundation

struct ScrapMagazineResponseDTO: Codable {
    let magazineScrapList: [MagazineDTO]

    enum CodingKeys: String, CodingKey {
        case magazineScrapList = "magazineScrapList"
    }
    
    public func toMagazineEntity() -> [MagazineEntity] {
        var magazineEntity: [MagazineEntity] = []
        _ = magazineScrapList.map { magazineDTO in
            magazineEntity.append(
                MagazineEntity(
                    id: magazineDTO.magazineID,
                    thumbnailImageURL: magazineDTO.thumbNail,
                    title: magazineDTO.title,
                    author: magazineDTO.interviewPerson,
                    isScrap: magazineDTO.isScraped,
                    url: "",
                    visibilityCount: magazineDTO.view
                )
            )
        }
        return magazineEntity
    }
}
