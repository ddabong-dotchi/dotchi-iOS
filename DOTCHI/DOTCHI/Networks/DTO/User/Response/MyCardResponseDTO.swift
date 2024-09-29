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

    enum CodingKeys: String, CodingKey {
        case username, cardId, title, type, imageUrl
    }
}

typealias MyCardResponseDTOList = [MyCardResponseDTO]

extension MyCardResponseDTOList {
    func toCardFrontEntity() -> [CardFrontEntity] {
        return self.map { card in
            CardFrontEntity(
                cardId: card.cardId,
                imageUrl: card.imageUrl,
                luckyType: LuckyType(rawValue: card.type) ?? .lucky,
                dotchiName: card.title
            )
        }
    }
}
