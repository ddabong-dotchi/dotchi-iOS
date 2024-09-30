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
    case deleteBlacklists(targetId: Int)
    case checkUsernameDuplicate(data: String)
    case checkNicknameDuplicate(data: String)
    case requestSignup(data: SignupRequestDTO)
    case reportUser(data: ReportUserRequestDTO)
//    case requestBlockUser(targetId: Int)
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
        case .getBlacklists, .deleteBlacklists:
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
        case .requestSignup, .reportUser:
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
        case .deleteBlacklists(let targetId):
            return .requestParameters(parameters: ["targetId": targetId], encoding: URLEncoding.queryString)
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
