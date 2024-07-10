//
//  SigninRequestDTO.swift
//  DOTCHI
//
//  Created by Jungbin on 7/11/24.
//

import Foundation

struct SigninRequestDTO: Encodable {
    let userID: String
    let password: String
}
