//
//  RequestBlockUserResponseDTO.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 10/12/24.
//


import Foundation

// MARK: - RequestBlockUserResponseDTO
struct RequestBlockUserResponseDTO: Codable {
    let id: Int
    let username, targetUsername, target: String
}
