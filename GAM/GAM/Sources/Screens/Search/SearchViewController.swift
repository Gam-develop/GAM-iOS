//
//  SearchViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/10.
//

import UIKit
import SnapKit

final class SearchViewController: BaseViewController {
    
    enum SearchType {
        case magazine
        case portfolio
    }
    
    // MARK: UIComponents
    
    // MARK: Properties
    
    private var searchType: SearchType = .magazine
    
    // MARK: Initializer
    
    init(searchType: SearchType) {
        super.init(nibName: nil, bundle: nil)
        
        self.searchType = searchType
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

extension SearchViewController {
    private func setLayout() {
        self.view.addSubviews([])
    }
}
