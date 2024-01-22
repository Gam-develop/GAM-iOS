//
//  BrowseDiscoverViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/15.
//

import UIKit
import SnapKit

final class BrowseDiscoverViewController: BaseViewController {
    
    private enum Number {
        static let cellHorizonInset = 24.0
        static let cellTopInset = 26.0
        static let cellBottomInset = 32.0
    }
    
    // MARK: UIComponents
    
    private var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.isPagingEnabled = false
        collectionView.contentInset = .init(top: 0, left: 24, bottom: 0, right: 24)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.layoutMargins = .zero
        collectionView.decelerationRate = .fast
        return collectionView
    }()
    
    // MARK: Properties
    
    private var superViewController: BrowseViewController?
    
    private var designers: [BrowseDesignerEntity] = []
    
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
        self.setCollectionViewLayout()
        self.setCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchData()
    }
    
    // MARK: Methods
    
    private func setCollectionViewLayout() {
        let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = .init(
            width: self.view.frame.width - Number.cellHorizonInset * 2,
            height: 528.adjustedH
        )
        collectionViewLayout.minimumLineSpacing = 12
        collectionViewLayout.scrollDirection = .horizontal
        
        self.collectionView.collectionViewLayout = collectionViewLayout
    }
    
    private func setCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.register(cell: BrowseDiscoverCollectionViewCell.self)
    }
    
    private func fetchData() {
        self.getBrowseDesigner { designers in
            self.designers = designers
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension BrowseDiscoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.designers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrowseDiscoverCollectionViewCell.className, for: indexPath) as? BrowseDiscoverCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.setData(data: self.designers[indexPath.row])
        cell.scrapButton.removeTarget(nil, action: nil, for: .allTouchEvents)
        cell.scrapButton.setAction { [weak self] in
            if let bool = self?.designers[indexPath.row].isScrap {
                self?.requestScrapDesigner(data: .init(targetUserId: self?.designers[indexPath.row].userId ?? 0, currentScrapStatus: bool)) {
                    self?.designers[indexPath.row].isScrap = !bool
                    cell.scrapButton.isSelected = !bool
                }
            }
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BrowseDiscoverViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(UserViewController(userID: self.designers[indexPath.row].userId), animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity:CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = self.collectionView.collectionViewLayout as?UICollectionViewFlowLayout else { return }
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        offset = CGPoint(
            x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left,
            y: scrollView.contentInset.top
        )
        targetContentOffset.pointee = offset
    }
}

// MARK: - Network

extension BrowseDiscoverViewController {
    private func getBrowseDesigner(completion: @escaping ([BrowseDesignerEntity]) -> ()) {
        self.startActivityIndicator()
        UserService.shared.getBrowseDesigner { networkResult in
            switch networkResult {
            case .success(let responseData):
                if let result = responseData as? GetBrowseDesignerResponseDTO {
                    completion(result.toBrowseDesignerEntity())
                }
            default:
                self.showNetworkErrorAlert()
            }
            self.stopActivityIndicator()
        }
    }
}

// MARK: - UI

extension BrowseDiscoverViewController {
    private func setLayout() {
        self.view.addSubviews([collectionView])
        
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
