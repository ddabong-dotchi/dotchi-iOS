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
    let mood: String = ""
    let content: String = ""

    enum CodingKeys: String, CodingKey {
        case id, nickname
        case userImageURL = "userImageUrl"
        case title, type, commentCount, createdAt, mood, content
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
    
    func toCardEntity() -> [CardEntity] {
        return self.map { card in
            CardEntity(
                user: CardUserEntity(
                    userId: -1,
                    profileImageUrl: card.userImageURL,
                    username: "",
                    nickname: card.nickname
                ),
                front: CardFrontEntity(
                    cardId: card.id,
                    imageUrl: card.imageURL,
                    luckyType: LuckyType(rawValue: card.type) ?? .lucky,
                    dotchiName: card.title
                ),
                back: CardBackEntity(
                    cardId: card.id,
                    dotchiName: card.title,
                    dotchiMood: card.mood,
                    dotchiContent: card.content,
                    luckyType: LuckyType(rawValue: card.type) ?? .lucky
                )
            )
        }
    }
}
