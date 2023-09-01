//
//  DesignerService.swift
//  GAM
//
//  Created by Jungbin on 2023/08/24.
//

import Foundation
import Moya

internal protocol DesignerServiceProtocol {
    func getPopularDesigner(completion: @escaping (NetworkResult<Any>) -> (Void))
}

final class DesignerService: BaseService {
    static let shared = DesignerService()
    private lazy var provider = GamMoyaProvider<DesignerRouter>(isLoggingOn: true)
    
    private override init() {}
}

extension DesignerService: DesignerServiceProtocol {
    
    // [GET] 감 잡은 디자이너
    
    func getPopularDesigner(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.getPopularDesigner) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, PopularDesignerResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
