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

    enum CodingKeys: String, CodingKey {
        case thumbNail = "thumbNail"
        case title = "title"
        case interviewPerson = "interviewPerson"
        case viewCount = "viewCount"
    }
}

typealias SearchMagazineResponseDTO = [SearchMagazineResponseDTOElement]

