//
//  CommentEntity.swift
//  DOTCHI
//
//  Created by Jungbin on 6/28/24.
//

import Foundation

struct CommentEntity {
    let userId: Int
    let username: String
    let profileImageUrl: String
}

typealias CommentsEntity = [CommentEntity]
