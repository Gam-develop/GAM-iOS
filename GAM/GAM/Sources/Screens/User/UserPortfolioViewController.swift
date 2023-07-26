//
//  UserPortfolioViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/26.
//

import UIKit
import SnapKit

final class UserPortfolioViewController: BaseViewController {
    
    // MARK: UIComponents
    
    // MARK: Properties
    
    private var superViewController: UserViewController?
    
    // MARK: Initializer
    
    init(superViewController: UserViewController) {
        super.init(nibName: nil, bundle: nil)
        
        self.superViewController = superViewController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
    }
    
    // MARK: Methods
}

// MARK: - UI

extension UserPortfolioViewController {
    private func setLayout() {
        self.view.addSubviews([])
    }
}
