//
//  CommentService.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/29/24.
//

import Foundation
import Moya

internal protocol CommentServiceProtocol {
    func getComments(cardId: Int, completion: @escaping (NetworkResult<Any>) -> (Void))
    func postComment(cardId: Int, completion: @escaping (NetworkResult<Any>) -> (Void))
}

final class CommentService: BaseService {
    static let shared = CommentService()
    private lazy var provider = DotchiMoyaProvider<CommentRouter>(isLoggingOn: true)
    
    private override init() {}
    
    private func request<T: Decodable>(_ target: CommentRouter, decodingType: T.Type, completion: @escaping (NetworkResult<Any>) -> Void) {
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

extension CommentService: CommentServiceProtocol {
    
    // [GET] 댓글 조회
    
    func getComments(cardId: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.request(.getComments(cardId: cardId), decodingType: GetCommentsResponseDTO.self, completion: completion)
    }
    
    // [POST] 댓글 작성
    
    func postComment(cardId: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.request(.postComment(cardId: cardId), decodingType: PostCommentResponseDTO.self, completion: completion)
    }
}
