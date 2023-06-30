//
//  UITabBar+.swift
//  GAM
//
//  Created by Jungbin on 2023/06/30.
//

import UIKit

extension UITabBar {
    
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
