//
//  LabelViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/01.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LabelViewController: UIViewController {
    // MARK: Constants
    private enum Metric {
    }
    
    // MARK: UIs
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    // MARK: Properties
    var titleText: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    var id: String? {
        titleText
    }
    
    // MARK: Configures
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = randomColor
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
