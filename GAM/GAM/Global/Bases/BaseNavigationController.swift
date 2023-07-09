//
//  BaseNavigationController.swift
//  GAM
//
//  Created by Jungbin on 2023/06/30.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    // MARK: Initializer
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
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
