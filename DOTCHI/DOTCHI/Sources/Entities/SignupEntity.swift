//
//  SignupEntity.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 8/25/24.
//

import UIKit.UIImage

struct SignupEntity {
    var username: String = ""
    var password: String = ""
    var nickname: String = ""
    var description: String = ""
    var profileImage: UIImage = UIImage()
    
    func toSignupRequestDTO() -> SignupRequestDTO {
        return SignupRequestDTO(
            username: self.username,
            password: self.password,
            nickname: self.nickname,
            description: self.description,
            profileImage: self.profileImage.jpegData(compressionQuality: 0.8) ?? Data()
        )
    }
}
