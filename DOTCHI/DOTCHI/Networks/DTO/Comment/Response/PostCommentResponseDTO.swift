//
//  PostCommentResponseDTO.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/29/24.
//

import Foundation

struct PostCommentResponseDTO: Decodable {
    let id: Int
    let nickname, cardWriter, type: String
}
