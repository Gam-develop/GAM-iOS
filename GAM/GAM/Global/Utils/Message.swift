//
//  Message.swift
//  GAM
//
//  Created by Jungbin on 2023/06/30.
//

enum Message {
    case networkError
}

extension Message {
    
    var text: String {
        switch self {
        case .networkError:
            return
"""
네트워크 오류로 인해 연결에 실패하였습니다.
잠시 후에 다시 시도해 주세요.
"""
        }
    }
}
