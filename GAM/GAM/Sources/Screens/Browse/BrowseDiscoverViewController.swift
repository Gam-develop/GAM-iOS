//
//  BrowseDiscoverViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/15.
//

import UIKit
import SnapKit

final class BrowseDiscoverViewController: BaseViewController {
    
    // MARK: UIComponents
    
    // MARK: Properties
    
    private var superViewController: BrowseViewController?
    
    // MARK: Initializer
    
    init(superViewController: BrowseViewController) {
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

extension BrowseDiscoverViewController {
    private func setLayout() {
        self.view.addSubviews([])
    }
}
