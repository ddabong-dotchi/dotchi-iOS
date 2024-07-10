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
}

extension AuthRouter: TargetType {

    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }

    var path: String {
        switch self {
        case .requestSignin:
            return "/user/login"
        }
    }

    var method: Moya.Method {
        switch self {
        case .requestSignin:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .requestSignin(let data):
            return .requestJSONEncodable(data)
        }
    }

    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
