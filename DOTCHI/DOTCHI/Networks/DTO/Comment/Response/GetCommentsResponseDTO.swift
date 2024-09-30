//
//  GetCommentsResponseDTO.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/29/24.
//


// MARK: - GetCommentsResponseDTOElement
struct GetCommentsResponseDTOElement: Codable {
    let id: Int
    let nickname, cardWriter, type: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, nickname, cardWriter, type
        case imageURL = "imageUrl"
    }
    
    func toCommentEntity() -> CommentEntity {
        return CommentEntity(
            userId: self.id,
            username: self.nickname,
            profileImageUrl: self.imageURL
        )
    }
}

typealias GetCommentsResponseDTO = [GetCommentsResponseDTOElement]

extension GetCommentsResponseDTO {
    func hasComment(nickname: String) -> Bool {
        let hasComment = self.contains(where: { $0.nickname == nickname })
        return hasComment
    }
}
