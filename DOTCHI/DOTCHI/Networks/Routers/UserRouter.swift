//
//  UserRouter.swift
//  DOTCHI
//
//  Created by KimYuBin on 7/14/24.
//

import Foundation
import Moya

enum UserRouter {
    case getUser
    case editUser(data: EditUserRequestDTO)
    case changePassword(data: String)
    case getMyCard
    case getBlacklists
    case checkUsernameDuplicate(data: String)
    case checkNicknameDuplicate(data: String)
}

extension UserRouter: TargetType {

    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }

    var path: String {
        switch self {
        case .getUser, .editUser:
            return "/user/me"
        case .changePassword:
            return "/user/password"
        case .getMyCard:
            return "/user/me/card"
        case .getBlacklists:
            return "/blacklists"
        case .checkUsernameDuplicate:
            return "/user/username"
        case .checkNicknameDuplicate:
            return "/user/nickname"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getUser, .getMyCard, .getBlacklists, .checkUsernameDuplicate, .checkNicknameDuplicate:
            return .get
        case .editUser, .changePassword:
            return .patch
        }
    }

    var task: Task {
        switch self {
        case .getUser, .getMyCard, .getBlacklists:
            return .requestPlain
        case .editUser(let data):
            var formData = [MultipartFormData]()
            
            if let jsonData = try? JSONEncoder().encode(data) {
                formData.append(MultipartFormData(
                    provider: .data(jsonData),
                    name: "request",
                    fileName: "request.json",
                    mimeType: "application/json"
                ))
            }
            
            if let imageData = data.profileImage {
                formData.append(MultipartFormData(
                    provider: .data(imageData),
                    name: "profileImage",
                    fileName: "profileImage.jpg",
                    mimeType: "image/jpeg"
                ))
            }
            
            return .uploadMultipart(formData)
        case .changePassword(let data):
            return .requestParameters(parameters: ["password": data], encoding: JSONEncoding.default)
        case .checkUsernameDuplicate(let data):
            return .requestParameters(parameters: ["username": data], encoding: URLEncoding.queryString)
        case .checkNicknameDuplicate(let data):
            return .requestParameters(parameters: ["nickname": data], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .checkUsernameDuplicate, .checkNicknameDuplicate:
            return [
                "Content-Type": "application/json"
            ]
        default:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserInfo.shared.accessToken)",
            ]
        }
    }
}
