//
//  UITextView+.swift
//  GAM
//
//  Created by Juhyeon Byun on 3/20/24.
//

import UIKit

extension UITextView {
    
    func setTextWithStyle(to targetString: String, style: UIFont, color: UIColor) {
        let text = targetString
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttribute(
            .font,
            value: style,
            range: (text as NSString).range(of: targetString)
        )
        
        attributedString.addAttribute(
            .foregroundColor,
            value: color,
            range: (text as NSString).range(of: targetString)
        )
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        switch style {
        case .headline4Bold:
            paragraphStyle.lineSpacing = style.pointSize * 0.15
        default:
            paragraphStyle.lineSpacing = style.pointSize * 0.24
        }
        
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineBreakStrategy = .hangulWordPriority
        
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        
        self.attributedText = attributedString
    }
}
