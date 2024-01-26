//
//  SecessionTableViewCell.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/24/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class SecessionTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let checkbox: UIButton = {
        let button = UIButton()
        button.setImage(.checkboxOff, for: .normal)
        button.setImage(.checkboxOn, for: .selected)
        return button
    }()
    
    private let reasonLabel = GamSingleLineLabel(text: "", font: .body1Regular)
 
    // MARK: Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setLayout()
    }
}

// MARK: - Methods

extension SecessionTableViewCell {
    
    func setReasonLabel(_ label: String) {
        self.reasonLabel.text = label
    }
    
    var checkboxTap: ControlEvent<Void> {
        return checkbox.rx.tap
    }

    func setSelectedState() -> Bool {
        self.checkbox.isSelected.toggle()
        return self.checkbox.isSelected
    }
}

// MARK: - UI

extension SecessionTableViewCell {
    
    private func setLayout() {
        self.contentView.backgroundColor = .gamGray1
        [checkbox, reasonLabel].forEach { self.contentView.addSubview($0) }
        
        self.checkbox.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(23)
        }

        self.reasonLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(checkbox.snp.trailing).offset(10)
        }
    }
}
