//
//  CardService.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/22/24.
//

import Foundation
import Moya

internal protocol CardServiceProtocol {
    func getAllCards(sort: CardSortType, completion: @escaping (NetworkResult<Any>) -> (Void))
}

final class CardService: BaseService {
    static let shared = CardService()
    private lazy var provider = DotchiMoyaProvider<CardRouter>(isLoggingOn: true)
    
    private override init() {}
}

extension CardService: CardServiceProtocol {
    
    // [GET] 전체 카드 조회(최신순, 인기순)
    
    func getAllCards(sort: CardSortType, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.getAllCards(sort: sort)) { result in
            switch result {
                case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, CardListResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
