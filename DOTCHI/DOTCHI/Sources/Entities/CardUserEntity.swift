//
//  CardUserEntity.swift
//  DOTCHI
//
//  Created by Jungbin on 6/28/24.
//

import Foundation

struct CardUserEntity {
    let userId: Int
    let profileImageUrl: String
    let username: String
    let nickname: String
    
    init(userId: Int, profileImageUrl: String, username: String, nickname: String) {
        self.userId = userId
        self.profileImageUrl = profileImageUrl
        self.username = username
        self.nickname = nickname
    }
    
    init() {
        self.userId = 0
        self.profileImageUrl = ""
        self.username = ""
        self.nickname = ""
    }
}
