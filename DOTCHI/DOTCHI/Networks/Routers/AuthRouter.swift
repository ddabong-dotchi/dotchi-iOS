//
//  AuthRouter.swift
//  DOTCHI
//
//  Created by Jungbin on 7/11/24.
//

import Foundation
import Moya

enum AuthRouter {
    case requestSignin(data: SigninRequestDTO)
    case logout
    case deleteAccount
}

extension AuthRouter: TargetType {

    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }

    var path: String {
        switch self {
        case .requestSignin:
            return "/user/login"
        case .logout:
            return "/user/logout"
        case .deleteAccount:
            return "/user/me"
        }
    }

    var method: Moya.Method {
        switch self {
        case .requestSignin:
            return .post
        case .logout:
            return .get
        case .deleteAccount:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case .requestSignin(let data):
            return .requestJSONEncodable(data)
        case .logout:
            return .requestPlain
        case .deleteAccount:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .logout, .deleteAccount:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserInfo.shared.accessToken)",
            ]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
