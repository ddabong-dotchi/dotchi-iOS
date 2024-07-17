//
//  BlacklistResponseDTO.swift
//  DOTCHI
//
//  Created by KimYuBin on 7/15/24.
//

import Foundation

struct BlacklistResponseDTO: Codable {
    let statusCode: String
    let message: String
    let content: [BlacklistResultDTO]
}

struct BlacklistResultDTO: Codable {
    let id: Int
    let username: String
    let target: String
    let targetNickname: String
    let targetImageUrl: String
}
