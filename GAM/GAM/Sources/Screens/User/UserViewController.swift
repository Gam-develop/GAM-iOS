//
//  UserViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/26.
//

import UIKit
import SnapKit

final class UserViewController: BaseViewController {
    
    // MARK: UIComponents
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
    }
    
    // MARK: Methods
}

// MARK: - UI

extension UserViewController {
    private func setLayout() {
        self.view.addSubviews([])
    }
}
