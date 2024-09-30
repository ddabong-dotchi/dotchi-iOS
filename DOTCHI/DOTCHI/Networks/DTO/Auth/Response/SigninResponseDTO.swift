//
//  SigninResponseDTO.swift
//  DOTCHI
//
//  Created by Jungbin on 7/11/24.
//

import Foundation

struct SigninResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let id: Int?
    let username: String?
    let nickname: String?
    let description: String?
    let imageUrl: String?
}
