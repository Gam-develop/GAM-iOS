//
//  NetworkResult.swift
//  GAM
//
//  Created by Jungbin on 2023/06/30.
//

enum NetworkResult<ResponseData> {
    case success(ResponseData)
    case requestErr(ResponseData)
    case pathErr
    case serverErr
    case networkFail
}
