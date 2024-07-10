//
//  NetworkResult.swift
//  DOTCHI
//
//  Created by Jungbin on 7/10/24.
//

enum NetworkResult<ResponseData> {
    case success(ResponseData)
    case requestErr(ResponseData)
    case pathErr
    case serverErr
    case networkFail
}
