//
//  MyCardResponseDTO.swift
//  DOTCHI
//
//  Created by KimYuBin on 7/14/24.
//

import Foundation

struct MyCardResponseDTO: Codable {
    let statusCode: String
    let message: String
    let content: [MyCardResultDTO]
}

struct MyCardResultDTO: Codable {
    let username: String
    let cardId: Int
    let title: String
    let type: String
    let imageUrl: String
}
