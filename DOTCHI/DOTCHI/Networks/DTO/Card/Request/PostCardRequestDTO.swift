//
//  PostCardRequestDTO.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/29/24.
//

import Foundation

struct PostCardRequestDTO: Encodable {
    var title: String = ""
    var mood: String = ""
    var content: String = ""
    var type: String = ""
    var imageUrl: String = ""
}
