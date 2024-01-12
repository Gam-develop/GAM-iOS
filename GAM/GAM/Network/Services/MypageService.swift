//
//  MypageService.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/8/24.
//

import Foundation
import Moya

internal protocol MypageServiceProtocol {
    func getPortfolio(completion: @escaping (NetworkResult<Any>) -> (Void))
    func setRepPortfolio(data: SetPortfolioRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void))
    func deletePortfolio(data: SetPortfolioRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void))
    func createPortfolio(data: CreatePortfolioRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void))
    func getImageUrl(data: ImageUrlRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void))
    func uploadImage(data: UploadImageRequestDTO, completion: @escaping () -> ())
    func updateLink(contactUrlType: ContactURLType, data: UpdateLinkRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void))
    func updatePortfolio(data: UpdatePortfolioRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void))
    func getProfile(completion: @escaping (NetworkResult<Any>) -> (Void))
}

final class MypageService: BaseService {
    static let shared = MypageService()
    private lazy var provider = GamMoyaProvider<MypageRouter>(isLoggingOn: true)
    
    private override init() {}
}

extension MypageService: MypageServiceProtocol {
    
    // [GET] 포트폴리오 리스트 조회
    
    func getPortfolio(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.getPortfolio) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, PortfolioResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [PATCH] 대표 프로젝트로 설정
    
    func setRepPortfolio(data: SetPortfolioRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.setRepPortfolio(data: data)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, String.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [DELETE] 프로젝트 삭제
    func deletePortfolio(data: SetPortfolioRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.deletePortfolio(data: data)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, DefaultPortfolioResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [POST] 프로젝트 생성
    func createPortfolio(data: CreatePortfolioRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.createPortfolio(data: data)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, DefaultPortfolioResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [GET] 이미지 url 받아오기
    func getImageUrl(data: ImageUrlRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.getImageUrl(data: data)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, ImageUrlResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [PUT] 이미지 업로드
    func uploadImage(data: UploadImageRequestDTO, completion: @escaping () -> ()) {
        self.provider.request(.uploadImage(data: data)) { result in
            switch result {
            case .success(_):
                completion()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [PATCH] 링크 업데이트
    func updateLink(contactUrlType: ContactURLType, data: UpdateLinkRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.updateLink(contactUrlType: contactUrlType, data: data)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, String.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [PATCH] 프로젝트 수정
    func updatePortfolio(data: UpdatePortfolioRequestDTO, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.updatePortfolio(data: data)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, DefaultPortfolioResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // [GET] 프로필 조회
    func getProfile(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        self.provider.request(.getProfile) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, ProfileResponseDTO.self)
                completion(networkResult)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
