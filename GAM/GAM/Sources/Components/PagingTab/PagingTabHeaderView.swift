//
//  PagingTabHeaderView.swift
//  GAM
//
//  Created by Jungbin on 2023/07/01.
//

import UIKit
import SnapKit
import RxSwift

typealias UpdateHeaderItemType = (Int, HeaderItemType)

struct HeaderItemType {
    let title: String
    var isSelected: Bool
}

final class PagingTabHeaderView: UIView {
    
    fileprivate enum Metric {
        static let interItemSpacing = 12.0
        static let underlineViewHeight = 4.0
        static let underlineViewTopSpacing = 6.0
        static let collectionViewBottomSpacing = underlineViewHeight + underlineViewTopSpacing
        static let duration = 0.2
    }
    
    // MARK: UIComponents
    
    let collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        return collectionView
    }()
    
    fileprivate let collectionViewLayout: UICollectionViewFlowLayout = {
        let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumInteritemSpacing = Metric.interItemSpacing
        return collectionViewLayout
    }()
    
    fileprivate let underlineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    // MARK: Properties
    
    fileprivate var items = [HeaderItemType]()
    fileprivate let disposeBag = DisposeBag()
    fileprivate let selectedPublish = PublishSubject<Int>()
    
    // MARK: Initializer
    
    init() {
        super.init(frame: .zero)
        
        self.setLayout()
        self.setCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init() has not been implemented")
    }
    
    // MARK: Methods
    
    private func setLayout() {
        self.addSubviews([collectionView, underlineView])
        
        self.collectionView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(Metric.collectionViewBottomSpacing)
        }
    }
    
    private func setCollectionView() {
        self.collectionView.collectionViewLayout = self.collectionViewLayout
        self.collectionView.register(cell: PagingHeaderCell.self, forCellWithReuseIdentifier: PagingHeaderCell.className)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        DispatchQueue.main.async {
            self.rx.updateUnderline.onNext(0)
        }
    }
    
    fileprivate func itemSize(index: Int) -> CGSize {
        return self.items[index].title.size(OfFont: .systemFont(ofSize: 18))
    }
}

extension PagingTabHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PagingHeaderCell.className, for: indexPath) as? PagingHeaderCell
        else { return UICollectionViewCell() }
        
        Observable
            .just(items[indexPath.item])
            .bind(to: cell.rx.prepare)
            .disposed(by: cell.disposeBag)
        
        cell.rx.onTap
            .mapTo(indexPath.item)
            .bind(to: selectedPublish.asObserver())
            .disposed(by: cell.disposeBag)
        
        return cell
    }
}

extension PagingTabHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        itemSize(index: indexPath.item)
    }
}

extension Reactive where Base: PagingTabHeaderView {
    var onIndexSelected: Observable<Int> {
        base.selectedPublish.asObservable()
    }
    
    var setItems: Binder<[HeaderItemType]> {
        Binder(base) { base, items in
            base.items = items
            base.collectionView.reloadData()
        }
    }
    
    var updateCells: Binder<[UpdateHeaderItemType]> {
        Binder(base) { base, items in
            items.forEach { ind, item in
                base.items[ind] = item
            }
            let indexPaths = items.map { ind, item in IndexPath(item: ind, section: 0) }
            UIView.performWithoutAnimation {
                base.collectionView.reloadItems(at: indexPaths)
            }
        }
    }
    
    var updateUnderline: Binder<Int> {
        Binder(base) { base, index in
            let indexPath = IndexPath(item: index, section: 0)
            guard let cell = base.collectionView.cellForItem(at: indexPath) else { return }
            base.underlineView.snp.remakeConstraints {
                $0.left.right.equalTo(cell)
                $0.bottom.equalTo(cell).offset(PagingTabHeaderView.Metric.underlineViewTopSpacing)
                $0.height.equalTo(PagingTabHeaderView.Metric.underlineViewHeight)
            }
            UIView.animate(withDuration: PagingTabHeaderView.Metric.duration, delay: 0, animations: base.layoutIfNeeded)
        }
    }
    
    private func updateCellLayout(_ cell: UICollectionViewCell) {
        base.underlineView.snp.remakeConstraints {
            $0.left.right.equalTo(cell)
            $0.bottom.equalTo(cell).offset(PagingTabHeaderView.Metric.underlineViewTopSpacing)
            $0.height.equalTo(PagingTabHeaderView.Metric.underlineViewHeight)
        }
        UIView.animate(withDuration: PagingTabHeaderView.Metric.duration, delay: 0, animations: base.layoutIfNeeded)
    }
}
