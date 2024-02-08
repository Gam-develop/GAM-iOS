//
//  PopularMagazineResponseDTO.swift
//  GAM
//
//  Created by Jungbin on 2023/08/24.
//

import Foundation

struct MagazineResponseDTO: Codable {
    let magazineList: [MagazineDTO]

    enum CodingKeys: String, CodingKey {
        case magazineList = "magazineList"
    }
    
    public func toMagazineEntity() -> [MagazineEntity] {
        var magazineEntity: [MagazineEntity] = []
        _ = magazineList.map { magazineDTO in
            magazineEntity.append(
                MagazineEntity(
                    id: magazineDTO.magazineID,
                    thumbnailImageURL: magazineDTO.thumbNail,
                    title: magazineDTO.title,
                    author: magazineDTO.interviewPerson,
                    isScrap: magazineDTO.isScraped,
                    url: magazineDTO.magazineUrl,
                    visibilityCount: magazineDTO.view
                )
            )
        }
        return magazineEntity
    }
}

// MARK: - MagazineList
struct MagazineDTO: Codable {
    let magazineID: Int
    let thumbNail: String
    let title: String
    let interviewPerson: String
    let view: Int
    let isScraped: Bool
    let magazineUrl: String

    enum CodingKeys: String, CodingKey {
        case magazineID = "magazineId"
        case magazineUrl, isScraped, view, interviewPerson, title, thumbNail
    }
}
