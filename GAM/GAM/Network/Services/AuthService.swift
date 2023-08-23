//
//  AuthService.swift
//  GAM
//
//  Created by Jungbin on 2023/08/23.
//

import Foundation
import Moya

internal protocol AuthServiceProtocol {
    func requestSocialLogin(data: SocialLoginRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void))
}

final class AuthService: BaseService {
    static let shared = AuthService()
    private lazy var provider = GamMoyaProvider<AuthRouter>(isLoggingOn: true)
    
    private override init() {}
}

extension AuthService: AuthServiceProtocol {
    
    // [POST] 소셜로그인
    
    func requestSocialLogin(data: SocialLoginRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.requestSocialLogin(data: data)) { result in
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
}
