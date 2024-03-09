//
//  ToastMessageType.swift
//  GAM
//
//  Created by Jungbin on 2023/08/02.
//

import Foundation

enum ToastMessageType {
    case completedCopy
    case completedUserBlock
    case completedUserReport
    case completedRemove
    case completedScrap
}

extension ToastMessageType {
    
    var text: String {
        switch self {
        case .completedCopy:
            return "✉️ 복사했어요"
        case .completedUserBlock:
            return "🚫 차단되었어요"
        case .completedUserReport:
            return "🚨 신고되었어요"
        case .completedRemove:
            return "🗑️ 삭제되었어요"
        case .completedScrap:
            return "👀 스크랩에 넣었어요"
        }
    }
}
