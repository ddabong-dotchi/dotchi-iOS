//
//  ImageResponseDTO.swift
//  DOTCHI
//
//  Created by 유빈 on 10/20/24.
//

import Foundation

struct ImageResponseDTO: Decodable {
    let preSignedUrl: String
    let imageUrl: String
}
