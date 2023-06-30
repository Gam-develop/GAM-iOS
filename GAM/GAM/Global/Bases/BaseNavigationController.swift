//
//  BaseNavigationController.swift
//  GAM
//
//  Created by Jungbin on 2023/06/30.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer?.delegate = self
        self.hideNavigationBar()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension BaseNavigationController: UIGestureRecognizerDelegate {
    
    /// NavigationBar를 안 쓰고 UIView로 네비바를 구현할 때, 스와이프로 뒤로 가기 가능하게 함
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1
    }
    
    func hideNavigationBar() {
        self.navigationBar.isHidden = true
    }
}
