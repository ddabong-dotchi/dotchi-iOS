//
//  SignupRequestDTO.swift
//  DOTCHI
//
//  Created by Jungbin on 8/2/24.
//

import Foundation

struct SignupRequestDTO: Encodable {
    var username: String = ""
    var password: String = ""
    var nickname: String = ""
    var description: String = ""
    var imageUrl: String = ""
}
