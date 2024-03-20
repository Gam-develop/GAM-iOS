//
//  Int+.swift
//  GAM
//
//  Created by Juhyeon Byun on 3/20/24.
//

import Foundation

extension Int {
    
    /// 숫자 1000 이상이면 1K, 1.2K 처럼 변경하는 메소드
    func formatToViews() -> String {
        if self >= 1000 {
            let formattedNumber = Double(self) / 1000.0
            return "\(String(format: "%.1f", formattedNumber).replacingOccurrences(of: ".0", with: ""))K"
        } else {
            return "\(self)"
        }
    }
}
