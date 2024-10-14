//
//  BlacklistResponseDTO.swift
//  DOTCHI
//
//  Created by KimYuBin on 7/15/24.
//

import Foundation

struct BlacklistResponseDTO: Codable {
    let id: Int
    let username: String
    let targetId: Int
    let targetUsername: String
    let targetNickname: String
    let targetImageUrl: String
}
