//
//  CardRouter.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/22/24.
//

import Foundation
import Moya

enum CardRouter {
    case getAllCards(sort: CardSortType)
    case getTodayCards
    case getCardLastTime(luckyType: LuckyType)
}

extension CardRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getAllCards: return "/cards"
        case .getTodayCards: return "/cards/top"
        case .getCardLastTime: return "/cards/last"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllCards, .getTodayCards, .getCardLastTime:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getAllCards(let sort):
            let parameters: [String: Any] = [
                "sort": sort.rawValue,
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getCardLastTime(let luckyType):
            return .requestParameters(parameters: ["type": luckyType.rawValue], encoding: URLEncoding.queryString)
        default: return .requestPlain
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
