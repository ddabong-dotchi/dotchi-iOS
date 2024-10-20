//
//  EditUserRequestDTO.swift
//  DOTCHI
//
//  Created by KimYuBin on 8/18/24.
//

import Foundation

struct EditUserRequestDTO: Encodable {
    var nickname: String
    var description: String
    var imageUrl: String?
}
