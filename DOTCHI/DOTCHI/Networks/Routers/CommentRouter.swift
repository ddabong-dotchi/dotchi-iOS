//
//  CommentRouter.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/29/24.
//

import Foundation
import Moya

enum CommentRouter {
    case getComments(cardId: Int)
    case postComment(cardId: Int)
}

extension CommentRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getComments(let cardId):
            return "/comments/\(cardId)"
        case .postComment:
            return "/comments"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getComments: return .get
        case .postComment:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getComments: return .requestPlain
        case .postComment(let cardId):
            let body: [String: Any] = ["cardId": cardId]
            return .requestParameters(parameters: body, encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        switch self {
        default:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserInfo.shared.accessToken)",
            ]
        }
    }
}
