//
//  MyCardResponseDTO.swift
//  DOTCHI
//
//  Created by KimYuBin on 7/14/24.
//

import Foundation

struct MyCardResponseDTO: Codable {
    let username: String
    let cardId: Int
    let title: String
    let type: String
    let imageUrl: String
}
