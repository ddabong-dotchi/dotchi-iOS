//
//  AuthService.swift
//  DOTCHI
//
//  Created by Jungbin on 7/11/24.
//

import Foundation
import Moya

internal protocol AuthServiceProtocol {
    func requestSignin(data: SigninRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void))
    func logout(completion: @escaping (NetworkResult<Any>) -> (Void))
}

final class AuthService: BaseService {
    static let shared = AuthService()
    private lazy var provider = DotchiMoyaProvider<AuthRouter>(isLoggingOn: true)
    
    private override init() {}
}

extension AuthService: AuthServiceProtocol {
    
    // [POST] 로그인
    
    func requestSignin(data: SigninRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.requestSignin(data: data)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, SigninResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [GET] 로그아웃
    
    func logout(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.logout) { result in
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
}
