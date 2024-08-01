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
    case getMyCard
    case getBlacklists
    case checkUsernameDuplicate(data: String)
}

extension UserRouter: TargetType {

    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }

    var path: String {
        switch self {
        case .getUser:
            return "/user/me"
        case .getMyCard:
            return "/user/me/card"
        case .getBlacklists:
            return "/blacklists"
        case .checkUsernameDuplicate:
            return "/user/username"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getUser, .getMyCard, .getBlacklists, .checkUsernameDuplicate:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getUser, .getMyCard, .getBlacklists:
            return .requestPlain
        case .checkUsernameDuplicate(let data):
            return .requestParameters(parameters: ["username": data], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .checkUsernameDuplicate:
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
