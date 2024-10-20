//
//  ImageService.swift
//  DOTCHI
//
//  Created by 유빈 on 10/20/24.
//

import Foundation
import Moya

internal protocol ImageServiceProtocol {
    func getPreSigned(fileName: String, completion: @escaping (NetworkResult<Any>) -> (Void))
    func uploadImageWithPreSignedUrl(preSignedUrl: String, imageData: Data, completion: @escaping (NetworkResult<Any>) -> Void)
}

final class ImageService: BaseService {
    static let shared = ImageService()
    private lazy var provider = DotchiMoyaProvider<ImageRouter>(isLoggingOn: true)
    
    private override init() {}
    
    private func request<T: Decodable>(_ target: ImageRouter, decodingType: T.Type, completion: @escaping (NetworkResult<Any>) -> Void) {
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

extension ImageService: ImageServiceProtocol {
    
    // [GET] preSignedUrl 발급
    
    func getPreSigned(fileName: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        self.provider.request(.getPreSigned(fileName: fileName)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, ImageResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
                completion(.networkFail)
            }
        }
    }
    
    // [PUT] 이미지를 preSignedUrl로 업로드
    
    func uploadImageWithPreSignedUrl(preSignedUrl: String, imageData: Data, completion: @escaping (NetworkResult<Any>) -> Void) {
        guard let url = URL(string: preSignedUrl) else {
            completion(.networkFail)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: imageData) { data, response, error in
            if let error = error {
                debugPrint("Upload failed with error: \(error)")
                completion(.networkFail)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.networkFail)
                return
            }
            
            if httpResponse.statusCode == 200 {
                completion(.success("Image uploaded successfully"))
            } else {
                completion(.networkFail)
            }
        }
        
        task.resume()
    }
}
