//
//  EditUserResponseDTO.swift
//  DOTCHI
//
//  Created by KimYuBin on 8/18/24.
//

import Foundation

struct EditUserResponseDTO: Codable {
    let username: String
    let nickname: String
    let description: String
    let imageUrl: String
}
