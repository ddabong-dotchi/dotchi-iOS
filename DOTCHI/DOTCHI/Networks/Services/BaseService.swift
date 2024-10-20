//
//  BaseService.swift
//  DOTCHI
//
//  Created by Jungbin on 7/10/24.
//

import Foundation
import Moya

class BaseService {
    func judgeStatus<T: Decodable>(by statusCode: Int, _ data: Data, _ type: T.Type) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        if type == ImageResponseDTO.self {
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return handleImageResponse(statusCode: statusCode, decodedData: decodedData)
            } catch {
                debugPrint("Decoding error (ImageResponseDTO): \(error)")
                return .pathErr
            }
        }
        
        guard let decodedData = try? decoder.decode(BaseResponseType<T>.self, from: data)
                
        else { return .pathErr }
        
        return handleBaseResponse(statusCode: statusCode, decodedData: decodedData)
    }
    
    private func handleBaseResponse<T>(statusCode: Int, decodedData: BaseResponseType<T>) -> NetworkResult<Any> {
        switch statusCode {
        case 200...210:
            if let data = decodedData.content {
                return .success(data)
            } else {
                debugPrint(decodedData.content as Any, "data type error, failed")
                return .success("data type error, failed")
            }
            
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func handleImageResponse<T>(statusCode: Int, decodedData: T) -> NetworkResult<Any> {
        switch statusCode {
        case 200...210:
            return .success(decodedData)
        case 400..<500:
            return .requestErr("Client error")
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
