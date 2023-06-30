//
//  NetworkResult.swift
//  GAM
//
//  Created by Jungbin on 2023/06/30.
//

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}
