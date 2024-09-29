//
//  PostCardResponseDTO.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/29/24.
//


struct PostCardResponseDTO: Codable {
    let id: Int
    let username, title, mood, content: String
    let type: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, username, title, mood, content, type
        case imageURL = "imageUrl"
    }
}