//
//  ImageRouter.swift
//  DOTCHI
//
//  Created by 유빈 on 10/19/24.
//

import Foundation
import Moya

enum ImageRouter {
    case getPreSigned(fileName: String)
}

extension ImageRouter: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getPreSigned:
            return "/s3/getPreSigned"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPreSigned:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getPreSigned(let fileName):
            return .requestParameters(parameters: ["fileName": fileName], encoding: URLEncoding.queryString)
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
