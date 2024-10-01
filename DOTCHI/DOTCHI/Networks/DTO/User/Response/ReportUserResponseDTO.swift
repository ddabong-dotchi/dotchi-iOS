//
//  ReportUserResponseDTO.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 10/1/24.
//

import Foundation

struct ReportUserResponseDTO: Decodable {
    let id: Int
    let username: String
    let targetID: Int
    let target: String

    enum CodingKeys: String, CodingKey {
        case id, username
        case targetID = "targetId"
        case target
    }
}
