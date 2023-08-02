//
//  MyProfileController.swift
//  GAM
//
//  Created by Jungbin on 2023/08/02.
//

import UIKit
import SnapKit

final class MyProfileController: BaseViewController {
    
    // MARK: UIComponents
    
    // MARK: Properties
    
    private var superViewController: MyViewController?
    
    // MARK: Initializer
    
    init(superViewController: MyViewController) {
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

extension MyProfileController {
    private func setLayout() {
        self.view.addSubviews([])
    }
}
