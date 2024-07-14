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
            return "user/me/card"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getUser:
            return .get
        case .getMyCard:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getUser:
            return .requestPlain
        case .getMyCard:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserInfo.shared.accessToken)",
        ]
    }
}
