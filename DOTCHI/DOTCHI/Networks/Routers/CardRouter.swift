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
    case postCard(data: PostCardRequestDTO)
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
        case .postCard: return "/cards"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllCards, .getTodayCards, .getCardLastTime:
            return .get
        case .postCard: return .post
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
        case .postCard(let data):
            var formData = [MultipartFormData]()
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            if let jsonData = try? encoder.encode(data),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                
                let requestData = MultipartFormData(provider: .data(jsonString.data(using: .utf8)!), name: "request")
                formData.append(requestData)
            }
            
            let imageMultipart = MultipartFormData(provider: .data(data.cardImage), name: "cardImage", fileName: "card.jpg", mimeType: "image/jpeg")
            formData.append(imageMultipart)
            
            return .uploadMultipart(formData)
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
