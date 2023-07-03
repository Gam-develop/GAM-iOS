//
//  PagingHeaderCell.swift
//  GAM
//
//  Created by Jungbin on 2023/07/01.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxSwiftExt

final class PagingHeaderCell: UICollectionViewCell {
    
    // MARK: UIComponents
    
    fileprivate let titleButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.setTitleColor(.black, for: .selected)
        button.tintColor = .clear
        return button
    }()
    
    // MARK: Properties
    
    private(set) var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
        self.rx.prepare.onNext(nil)
    }
    
    private func setLayout() {
        self.contentView.addSubview(titleButton)
        
        self.titleButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension Reactive where Base: PagingHeaderCell {
    var prepare: Binder<HeaderItemType?> {
        Binder(base) { base, itemType in
            base.titleButton.setTitle(itemType?.title, for: .normal)
            base.titleButton.setTitle(itemType?.title, for: .selected)
            base.titleButton.isSelected = itemType?.isSelected ?? false
        }
    }
    
    var onTap: Observable<Void> {
        base.titleButton.rx.tap.mapTo(()).asObservable()
    }
}
