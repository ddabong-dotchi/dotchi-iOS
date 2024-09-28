//
//  CardListResponseDTO.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/22/24.
//

struct CardListResponseDTOElement: Codable {
    let id: Int
    let nickname: String
    let userImageURL: String
    let title, type: String
    let commentCount: Int
    let createdAt: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, nickname
        case userImageURL = "userImageUrl"
        case title, type, commentCount, createdAt
        case imageURL = "imageUrl"
    }
}

typealias CardListResponseDTO = [CardListResponseDTOElement]

extension CardListResponseDTO {
    func toCardFrontEntity() -> [CardFrontEntity] {
        return self.map { card in
            CardFrontEntity(
                cardId: card.id,
                imageUrl: card.imageURL,
                luckyType: LuckyType.init(rawValue: card.type) ?? .lucky,
                dotchiName: card.title
            )
        }
    }
}
