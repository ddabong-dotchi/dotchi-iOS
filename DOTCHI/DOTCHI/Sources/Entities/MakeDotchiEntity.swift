//
//  MakeDotchiEntity.swift
//  DOTCHI
//
//  Created by Jungbin on 6/28/24.
//

import UIKit

struct MakeDotchiEntity {
    var image: UIImage
    var luckyType: LuckyType
    var dotchiName: String
    var dotchiMood: String
    var dotchiContent: String
    
    init() {
        self.image = UIImage()
        self.luckyType = .lucky
        self.dotchiName = ""
        self.dotchiMood = ""
        self.dotchiContent = ""
    }
    
    func toPostCardRequestData() -> PostCardRequestDTO {
        return PostCardRequestDTO(
            title: self.dotchiName,
            mood: self.dotchiMood,
            content: self.dotchiContent,
            type: self.luckyType.rawValue,
            cardImage: self.image.jpegData(compressionQuality: 0.8) ?? Data()
        )
    }
}
