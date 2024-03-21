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
    
    /// 특정 문자열 컬러, 폰트 변경하는 메서드 (대소문자 구분 X)
    func setFontColor(to targetString: String, font: UIFont, color: UIColor) {
        let lowerString: String = targetString.lowercased()
        
        if let labelText = self.text?.lowercased(), labelText.count > 0 {
            let attributedString = NSMutableAttributedString(
                attributedString: self.attributedText ?? NSAttributedString(string: labelText)
            )
            
            attributedString.addAttribute(
                .font,
                value: font,
                range: (labelText as NSString).range(of: lowerString)
            )
            
            attributedString.addAttribute(
                .foregroundColor,
                value: color,
                range: (labelText as NSString).range(of: lowerString))
            
            attributedText = attributedString
        }
    }
    
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
            paragraphStyle.minimumLineHeight = style.pointSize * 1.3
            paragraphStyle.maximumLineHeight = style.pointSize * 1.3
        default:
            paragraphStyle.minimumLineHeight = style.pointSize * 1.48
            paragraphStyle.maximumLineHeight = style.pointSize * 1.48
        }
        
        paragraphStyle.lineBreakMode = .byTruncatingTail
        
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        
        switch style {
        case .headline4Bold:
            attributedString.addAttribute(.baselineOffset, value: (style.pointSize * 1.3 - style.lineHeight) / 4, range: NSRange(location: 0, length: attributedString.length))
        default:
            attributedString.addAttribute(.baselineOffset, value: (style.pointSize * 1.48 - style.lineHeight) / 4, range: NSRange(location: 0, length: attributedString.length))
        }
        
        self.attributedText = attributedString
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
    
    /// 라벨 내 특정 문자열의 CGRect 반환
    /// - Parameter subText: CGRect값을 알고 싶은 특정 문자열
    func boundingRectForCharacterRange(subText: String) -> CGRect? {
        guard let attributedText = attributedText else { return nil }
        guard let text = self.text else { return nil }
        
        // 전체 텍스트(text)에서 subText만큼의 range를 구합니다.
        guard let subRange = text.range(of: subText) else { return nil }
        let range = NSRange(subRange, in: text)
        
        // attributedText를 기반으로 한 NSTextStorage를 선언하고 NSLayoutManager를 추가합니다.
        let layoutManager = NSLayoutManager()
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addLayoutManager(layoutManager)
        
        // instrinsicContentSize를 기반으로 NSTextContainer를 선언하고
        let textContainer = NSTextContainer(size: intrinsicContentSize)
        
        // 정확한 CGRect를 구해야하므로 padding 값은 0을 줍니다.
        textContainer.lineFragmentPadding = 0.0
        
        // layoutManager에 추가합니다.
        layoutManager.addTextContainer(textContainer)
        
        var glyphRange = NSRange()
        
        // 주어진 범위(rage)에 대한 실질적인 glyphRange를 구합니다.
        layoutManager.characterRange(
            forGlyphRange: range,
            actualGlyphRange: &glyphRange
        )
        
        // textContainer 내의 지정된 glyphRange에 대한 CGRect 값을 반환합니다.
        return layoutManager.boundingRect(
            forGlyphRange: glyphRange,
            in: textContainer
        )
    }
}
