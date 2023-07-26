//
//  MyViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/01.
//

import UIKit
import SnapKit

final class MyViewController: BaseViewController {
    
    // MARK: UIComponents
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
    }
    
    // MARK: Methods
}

// MARK: - UI

extension MyViewController {
    private func setLayout() {
        self.view.addSubviews([])
    }
}
