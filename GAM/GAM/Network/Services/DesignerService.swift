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
    func requestScrapDesigner(data: ScrapDesignerRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void))
    func getBrowseDesigner(completion: @escaping (NetworkResult<Any>) -> (Void))
    func getScrapDesigner(completion: @escaping (NetworkResult<Any>) -> (Void))
    func searchDesigner(data: String, completion: @escaping (NetworkResult<Any>) -> (Void))
    func getUserProfile(data: GetUserProfileRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void))
    func getUserPortfolio(data: GetUserPortfolioRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void))
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
    
    // [POST] 디자이너 스크랩
    
    func requestScrapDesigner(data: ScrapDesignerRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.requestScrapDesigner(data: data)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, ScrapDesignerResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [GET] 발견 - 디자이너
    
    func getBrowseDesigner(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.getBrowseDesigner) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, GetBrowseDesignerResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [GET] 발견 - 디자이너 스크랩
    
    func getScrapDesigner(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.getScrapDesigner) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, GetScrapDesignerResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [GET] 디자이너 검색
    
    func searchDesigner(data: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.searchDesigner(data: data)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, SearchDesignerResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [GET] 유저 프로필 조회
    
    func getUserProfile(data: GetUserProfileRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.getUserProfile(data: data)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, GetUserProfileResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [GET] 유저 포트폴리오 조회
    
    func getUserPortfolio(data: GetUserPortfolioRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.getUserPortfolio(data: data)) { result in
            print(result)
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, GetUserPortfolioResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
