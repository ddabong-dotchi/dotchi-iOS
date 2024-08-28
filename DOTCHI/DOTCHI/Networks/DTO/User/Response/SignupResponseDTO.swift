//
//  SignupResponseDTO.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 8/27/24.
//

import Foundation

struct SignupResponseDTO: Decodable {
    var id: Int = 0
    var username: String = ""
    var nickname: String = ""
    var description: String = ""
    var imageUrl: String? = nil
}
