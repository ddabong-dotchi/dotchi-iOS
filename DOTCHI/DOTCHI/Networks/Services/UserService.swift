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
    func checkUsernameDuplicate(data: String, completion: @escaping (NetworkResult<Any>) -> (Void))
    func checkNicknameDuplicate(data: String, completion: @escaping (NetworkResult<Any>) -> (Void))
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
                let networkResult = self.judgeStatus(by: statusCode, data, UserResponseDTO.self)
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
                let networkResult = self.judgeStatus(by: statusCode, data, MyCardResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [GET] 차단 목록 조회
    
    func getBlacklists(completion: @escaping (NetworkResult<Any>) -> Void) {
        self.provider.request(.getBlacklists) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, [BlacklistResponseDTO].self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
                completion(.networkFail)
            }
        }
    }
    
    // [GET] 중복 아이디 조회
    
    func checkUsernameDuplicate(data: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.checkUsernameDuplicate(data: data)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, Bool.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [GET] 중복 닉네임 조회
    
    func checkNicknameDuplicate(data: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.checkNicknameDuplicate(data: data)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, Bool.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
