//
//  UserService.swift
//  DOTCHI
//
//  Created by KimYuBin on 7/14/24.
//

import Foundation
import Moya
import UIKit

internal protocol UserServiceProtocol {
    func getUser(completion: @escaping (NetworkResult<Any>) -> (Void))
    func editUser(nickname: String, description: String, profileImage: UIImage?, completion: @escaping (NetworkResult<Any>) -> (Void))
    func checkUsernameDuplicate(data: String, completion: @escaping (NetworkResult<Any>) -> (Void))
    func checkNicknameDuplicate(data: String, completion: @escaping (NetworkResult<Any>) -> (Void))
    func requestSignup(data: SignupRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void))
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
    
    // [PATCH] 내 정보 수정
    
    func editUser(nickname: String, description: String, profileImage: UIImage?, completion: @escaping (NetworkResult<Any>) -> Void) {
        let imageData = profileImage?.jpegData(compressionQuality: 0.1)
        let requestData = EditUserRequestDTO(nickname: nickname, description: description, profileImage: imageData)
        
        self.provider.request(.editUser(data: requestData)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, EditUserResponseDTO.self)
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
            }
        }
    }
    
    // [GET] 중복 아이디 조회
    
    func checkUsernameDuplicate(data: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.request(.checkUsernameDuplicate(data: data), decodingType: Bool.self, completion: completion)
    }
    
    // [GET] 중복 닉네임 조회
    
    func checkNicknameDuplicate(data: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.request(.checkNicknameDuplicate(data: data), decodingType: Bool.self, completion: completion)
    }
    
    // [POST] 회원가입 요청
    
    func requestSignup(data: SignupRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.request(.requestSignup(data: data), decodingType: SignupResponseDTO.self, completion: completion)
    }
    
    private func request<T: Decodable>(_ target: UserRouter, decodingType: T.Type, completion: @escaping (NetworkResult<Any>) -> Void) {
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
