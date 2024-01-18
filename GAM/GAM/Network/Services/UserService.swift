//
//  UserService.swift
//  GAM
//
//  Created by Jungbin on 2023/08/23.
//

import Foundation
import Moya

internal protocol UserServiceProtocol {
    func requestSignUp(data: SignUpRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void))
    func checkUsernameDuplicated(data: String, completion: @escaping (NetworkResult<Any>) -> (Void))
}

final class UserService: BaseService {
    static let shared = UserService()
    private lazy var provider = GamMoyaProvider<UserRouter>(isLoggingOn: true)
    
    private override init() {}
}

extension UserService: UserServiceProtocol {
    
    // [POST] 회원가입
    
    func requestSignUp(data: SignUpRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.requestSignUp(data: data)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, SocialLoginResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [GET] 닉네임 중복 검사
    
    func checkUsernameDuplicated(data: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.checkUsernameDuplicated(data: data)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, CheckUsernameDuplicatedResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
