//
//  MagazineDetailViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/09.
//

import UIKit
import SnapKit

final class MagazineDetailViewController: BaseViewController {
    
    enum Text {
        static let title = "매거진"
    }
    // MARK: UIComponents
    
    private let navigationView: GamNavigationView = {
        let view: GamNavigationView = GamNavigationView(type: .backTitleShare)
        view.setCenterTitle(Text.title)
        return view
    }()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
    }
    
    // MARK: Methods
}

// MARK: - UI

extension MagazineDetailViewController {
    private func setLayout() {
        self.view.addSubviews([navigationView])
        
        self.navigationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
