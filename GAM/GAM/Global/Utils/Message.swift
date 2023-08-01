//
//  Message.swift
//  GAM
//
//  Created by Jungbin on 2023/06/30.
//

enum Message {
    case networkError
    case unabledMailApp
    case completedSendContactMail
    case failedSendContactMail
    case completedPaste
    case completedUserBlock
    case completedUserReport
    case completedRemove
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
        case .unabledMailApp:
            return "Mail 앱을 사용할 수 없습니다. 기기에 Mail 앱이 설치되어 있는지 확인해 주세요."
            
        case .completedSendContactMail:
            return "메일 전송이 완료되었습니다."
            
        case .failedSendContactMail:
            return "메일 전송에 실패하였습니다. 다시 시도해 주세요."
        case .completedPaste:
            return "✉️ 복사했어요"
        case .completedUserBlock:
            return "🚫 차단되었어요"
        case .completedUserReport:
            return "🚨 신고되었어요"
        case .completedRemove:
            return "🗑️ 삭제되었어요"
        }
    }
}
