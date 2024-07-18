//
//  UserResponseDTO.swift
//  DOTCHI
//
//  Created by KimYuBin on 7/14/24.
//

import Foundation

struct UserResponseDTO: Codable {
    let id: Int
    let username: String
    let nickname: String
    let description: String
    let imageUrl: String
}
