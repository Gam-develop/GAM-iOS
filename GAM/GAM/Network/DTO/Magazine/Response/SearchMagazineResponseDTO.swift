//
//  SearchMagazineResponseDTO.swift
//  GAM
//
//  Created by Jungbin on 1/8/24.
//

// MARK: - SearchMagazineResponseDTOElement
struct SearchMagazineResponseDTOElement: Codable {
    let thumbNail: String
    let title: String
    let interviewPerson: String
    let viewCount: Int
}

typealias SearchMagazineResponseDTO = [SearchMagazineResponseDTOElement]

extension SearchMagazineResponseDTO {
    func toMagazineEntity() -> [MagazineEntity] {
        var entity: [MagazineEntity] = []
        for i in 0..<self.count {
            entity.append(
                MagazineEntity(
                    id: i,
                    thumbnailImageURL: self[i].thumbNail,
                    title: self[i].title,
                    author: self[i].interviewPerson,
                    isScrap: false,
                    url: "",
                    visibilityCount: self[i].viewCount
                )
            )
        }
        
        return entity
    }
}
