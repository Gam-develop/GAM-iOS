//
//  RecentSearchTapGestureRecognizer.swift
//  GAM
//
//  Created by Jungbin on 2023/07/10.
//

import UIKit

final class RecentSearchTapGestureRecognizer: UITapGestureRecognizer {
    
    var keyword: String = ""
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
}
