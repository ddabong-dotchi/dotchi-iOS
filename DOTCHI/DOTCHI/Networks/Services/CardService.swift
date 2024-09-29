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
    func getTodayCards(completion: @escaping (NetworkResult<Any>) -> (Void))
    func getCardLastTime(luckyType: LuckyType, completion: @escaping (NetworkResult<Any>) -> (Void))
    func postCard(data: PostCardRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void))
    func getCardDetail(cardId: Int, completion: @escaping (NetworkResult<Any>) -> (Void))
    func deleteCard(cardId: Int, completion: @escaping (NetworkResult<Any>) -> (Void))
}

final class CardService: BaseService {
    static let shared = CardService()
    private lazy var provider = DotchiMoyaProvider<CardRouter>(isLoggingOn: true)
    
    private override init() {}
    
    private func request<T: Decodable>(_ target: CardRouter, decodingType: T.Type, completion: @escaping (NetworkResult<Any>) -> Void) {
        self.provider.request(target) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, decodingType)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
                completion(.networkFail)
            }
        }
    }
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
    
    // [GET] 오늘의 카드 조회
    
    func getTodayCards(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.getTodayCards) { result in
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
    
    // [GET] 타입별 최신 카드 업로드 시간
    
    func getCardLastTime(luckyType: LuckyType, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.getCardLastTime(luckyType: luckyType)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, String.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [POST] 카드 생성
    
    func postCard(data: PostCardRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.request(.postCard(data: data), decodingType: PostCardResponseDTO.self, completion: completion)
    }
    
    // [GET] 카드 상세정보 조회
    
    func getCardDetail(cardId: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.request(.getCardDetail(cardId: cardId), decodingType: CardDetailResponseDTO.self, completion: completion)
    }
    
    // [DELETE] 카드 삭제
    
    func deleteCard(cardId: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.request(.deleteCard(cardId: cardId), decodingType: String.self, completion: completion)
    }
}
