//
//  UILabel+.swift
//  GAM
//
//  Created by Jungbin on 2023/06/30.
//

import UIKit

extension UILabel {
    
    /// 특정 문자열 컬러 변경하는 메서드
    func setColor(to targetString: String, with color: UIColor) {
        if let labelText = self.text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(
                attributedString: self.attributedText ?? NSAttributedString(string: labelText)
            )
            
            attributedString.addAttribute(
                .foregroundColor,
                value: color,
                range: (labelText as NSString).range(of: targetString)
            )
            
            attributedText = attributedString
        }
    }
    
    /// 특정 문자열 폰트 변경하는 메서드
    func setFont(to targetString: String, with font: UIFont) {
        if let labelText = self.text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(
                attributedString: self.attributedText ?? NSAttributedString(string: labelText)
            )
            
            attributedString.addAttribute(
                .font,
                value: font,
                range: (labelText as NSString).range(of: targetString)
            )
            
            attributedText = attributedString
        }
    }
    
    /// 특정 문자열 컬러, 폰트 변경하는 메서드
    func setFontColor(to targetString: String, font: UIFont, color: UIColor) {
        if let labelText = self.text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(
                attributedString: self.attributedText ?? NSAttributedString(string: labelText)
            )
            
            attributedString.addAttribute(
                .font,
                value: font,
                range: (labelText as NSString).range(of: targetString)
            )
            
            attributedString.addAttribute(
                .foregroundColor,
                value: color,
                range: (labelText as NSString).range(of: targetString))
            
            attributedText = attributedString
        }
    }
    
    func setHyperlinkedStyle(to targetStrings: [String], with font: UIFont
    ) {
        if let labelText = self.text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            let linkAttributes : [NSAttributedString.Key: Any] = [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .font: font
            ]
            for targetString in targetStrings{
                attributedString.setAttributes(
                    linkAttributes,
                    range: (labelText as NSString).range(of: targetString))
            }
            
            attributedText = attributedString
        }
    }
}
