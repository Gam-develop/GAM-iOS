//
//  MagazineService.swift
//  GAM
//
//  Created by Jungbin on 2023/08/24.
//

import Foundation
import Moya

internal protocol MagazineServiceProtocol {
    func getPopularMagazine(completion: @escaping (NetworkResult<Any>) -> (Void))
    func getAllMagazine(completion: @escaping (NetworkResult<Any>) -> (Void))
}

final class MagazineService: BaseService {
    static let shared = MagazineService()
    private lazy var provider = GamMoyaProvider<MagazineRouter>(isLoggingOn: true)
    
    private override init() {}
}

extension MagazineService: MagazineServiceProtocol {
    
    // [GET] 영감 매거진
    
    func getPopularMagazine(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.getPopularMagazine) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, MagazineResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [GET] 모든 매거진(발견)
    
    func getAllMagazine(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.getAllMagazine) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, MagazineResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
