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
        guard let decodedData = try? decoder.decode(BaseResponseType<T>.self, from: data)
                
        else { return .pathErr }
        
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
}
