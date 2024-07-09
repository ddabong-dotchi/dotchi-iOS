//
//  BaseResponseType.swift
//  DOTCHI
//
//  Created by Jungbin on 7/10/24.
//

import Foundation

struct BaseResponseType<T: Decodable>: Decodable {
    
    var statusCode: String
    var message: String
    var content: T?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "statusCode"
        case message = "message"
        case content = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = (try? values.decode(String.self, forKey: .statusCode)) ?? ""
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        content = (try? values.decode(T.self, forKey: .content)) ?? nil
    }
}
