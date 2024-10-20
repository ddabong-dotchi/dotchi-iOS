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
    case deleteBlacklists(targetUsername: String)
    case checkUsernameDuplicate(data: String)
    case checkNicknameDuplicate(data: String)
    case requestSignup(data: SignupRequestDTO)
    case reportUser(data: ReportUserRequestDTO)
    case requestBlockUser(targetUsername: String)
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
        case .getBlacklists, .deleteBlacklists, .requestBlockUser:
            return "/blacklists"
        case .checkUsernameDuplicate:
            return "/user/username"
        case .checkNicknameDuplicate:
            return "/user/nickname"
        case .requestSignup:
            return "/user/join"
        case .reportUser:
            return "/reports"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getUser, .getMyCard, .getBlacklists, .checkUsernameDuplicate, .checkNicknameDuplicate:
            return .get
        case .editUser, .changePassword:
            return .patch
        case .requestSignup, .reportUser, .requestBlockUser:
            return .post
        case .deleteBlacklists:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case .getUser, .getMyCard, .getBlacklists:
            return .requestPlain
        case .editUser(let data):
            var parameters: [String: Any] = [
                "nickname": data.nickname,
                "description": data.description
            ]
            
            if let imageUrl = data.imageUrl {
                parameters["imageUrl"] = imageUrl
            }
            
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .changePassword(let data):
            return .requestParameters(parameters: ["password": data], encoding: JSONEncoding.default)
        case .deleteBlacklists(let targetUsername):
            return .requestParameters(parameters: ["targetUsername": targetUsername], encoding: URLEncoding.queryString)
        case .checkUsernameDuplicate(let data):
            return .requestParameters(parameters: ["username": data], encoding: URLEncoding.queryString)
        case .checkNicknameDuplicate(let data):
            return .requestParameters(parameters: ["nickname": data], encoding: URLEncoding.queryString)
        case .requestSignup(let data):
            var formData = [MultipartFormData]()
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            if let jsonData = try? encoder.encode(data),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                
                let requestData = MultipartFormData(provider: .data(jsonString.data(using: .utf8)!), name: "request")
                formData.append(requestData)
            }
            
            let imageMultipart = MultipartFormData(provider: .data(data.profileImage), name: "profileImage", fileName: "profile.jpg", mimeType: "image/jpeg")
            formData.append(imageMultipart)
            
            return .uploadMultipart(formData)
        case .reportUser(let data):
            return .requestJSONEncodable(data)
        case .requestBlockUser(let targetUsername):
            return .requestParameters(parameters: ["targetUsername": targetUsername], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .checkUsernameDuplicate, .checkNicknameDuplicate:
            return [
                "Content-Type": "application/json"
            ]
        case .requestSignup:
            return ["Content-Type": "multipart/form-data"]
        default:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserInfo.shared.accessToken)",
            ]
        }
    }
}
