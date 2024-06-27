//
//  CardEntity.swift
//  DOTCHI
//
//  Created by Jungbin on 6/28/24.
//

import Foundation

struct CardEntity {
    let user: CardUserEntity
    let front: CardFrontEntity
    let back: CardBackEntity
    var commentsCount: Int = APIConstants.pagingDefaultValue
}
