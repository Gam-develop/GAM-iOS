//
//  MypageViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/01.
//

import UIKit
import SnapKit

final class MypageViewController: BaseViewController {
    
    // MARK: UIComponents
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
    }
    
    // MARK: Methods
}

// MARK: - UI

extension MypageViewController {
    private func setLayout() {
        self.view.addSubviews([])
    }
}
