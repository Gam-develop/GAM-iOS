//
//  FilterViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/24.
//

import UIKit
import SnapKit

final class FilterViewController: BaseViewController {
    
    private enum Text {
        static let title = "필터"
    }
    
    // MARK: UIComponents
    
    private let titleLabel: Headline1Label = Headline1Label(text: Text.title)
//    private let
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.setUI()
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.view.backgroundColor = .gamWhite
    }
}

// MARK: - UI

extension FilterViewController {
    private func setLayout() {
        self.view.addSubviews([titleLabel])
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(37)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
    }
}
