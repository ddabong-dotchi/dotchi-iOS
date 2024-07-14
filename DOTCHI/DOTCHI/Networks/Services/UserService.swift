//
//  UserService.swift
//  DOTCHI
//
//  Created by KimYuBin on 7/14/24.
//

import Foundation
import Moya

internal protocol UserServiceProtocol {
    func getUser(completion: @escaping (NetworkResult<Any>) -> (Void))
}

final class UserService: BaseService {
    static let shared = UserService()
    private lazy var provider = DotchiMoyaProvider<UserRouter>(isLoggingOn: true)
    
    private override init() {}
}

extension UserService: UserServiceProtocol {
    
    // [GET] 내 정보 조회
    
    func getUser(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.getUser) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, UserResultDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [GET] 내 카드 조회
    
    func getMyCard(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.getMyCard) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, MyCardResultDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
