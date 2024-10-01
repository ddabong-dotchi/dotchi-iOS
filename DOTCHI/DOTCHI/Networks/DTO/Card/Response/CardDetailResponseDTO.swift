//
//  CardDetailResponseDTO.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/29/24.
//


import Foundation

// MARK: - CardDetailResponseDTO
struct CardDetailResponseDTO: Codable {
    let id: Int
    let username, nickname: String
    let userImageURL: String
    let title, mood, content, type: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, username, nickname
        case userImageURL = "userImageUrl"
        case title, mood, content, type
        case imageURL = "imageUrl"
    }
    
    func toCardUserEntity() -> CardUserEntity {
        return CardUserEntity(
            userId: -1,
            profileImageUrl: self.userImageURL,
            username: self.username,
            nickname: self.nickname
        )
    }
    
    func toCardFrontEntity() -> CardFrontEntity {
        return CardFrontEntity(
            cardId: self.id,
            imageUrl: self.imageURL,
            luckyType: LuckyType(rawValue: self.type) ?? .lucky,
            dotchiName: self.title
        )
    }
    
    func toCardBackEntity() -> CardBackEntity {
        return CardBackEntity(
            cardId: self.id,
            dotchiName: self.title,
            dotchiMood: self.mood,
            dotchiContent: self.content,
            luckyType: LuckyType(rawValue: self.type) ?? .lucky
        )
    }
}
