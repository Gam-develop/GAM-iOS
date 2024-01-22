//
//  BrowseScrapViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/15.
//

import UIKit
import SnapKit

final class BrowseScrapViewController: BaseViewController {
    
    private enum Number {
        static let headerHeight = 52.0
        static let magazineCellHeight = 140.0
        static let magazineCellSpacing = 18.0
    }
    
    // MARK: UIComponents
    
    private let collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.backgroundColor = .clear
        collectionView.register(
            BrowseScrapCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: BrowseScrapCollectionHeaderView.className
        )
        collectionView.register(cell: BrowseScrapCollectionViewCell.self)
        collectionView.contentInset = .init(top: 0, left: 20, bottom: 28, right: 20)
        return collectionView
    }()
    
    // MARK: Properties
    
    private var superViewController: BrowseViewController?
    private var designers: [BrowseDesignerScrapEntity] = []
    
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
        self.setCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchData()
    }
    
    // MARK: Methods
    
    private func setCollectionView() {
        let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = .init(width: (self.screenWidth - 40 - 15) / 2, height: 204)
        collectionViewLayout.headerReferenceSize = .init(width: self.screenWidth, height: 52)
        self.collectionView.collectionViewLayout = collectionViewLayout
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    private func fetchData() {
        self.getScrapDesigner { designers in
            self.designers = designers
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension BrowseScrapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.designers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrowseScrapCollectionViewCell.className, for: indexPath) as? BrowseScrapCollectionViewCell
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: BrowseScrapCollectionHeaderView.className,
                for: indexPath
              ) as? BrowseScrapCollectionHeaderView
        else { return UICollectionReusableView() }
        supplementaryView.setCount(count: self.designers.count)
        return supplementaryView
    }
}

// MARK: - UICollectionViewDelegate

extension BrowseScrapViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let portfolioDetailViewController: BaseViewController = UserViewController(userID: self.designers[indexPath.row].userId)
        self.navigationController?.pushViewController(portfolioDetailViewController, animated: true)
    }
}

// MARK: - Network

extension BrowseScrapViewController {
    private func getScrapDesigner(completion: @escaping ([BrowseDesignerScrapEntity]) -> ()) {
        self.startActivityIndicator()
        UserService.shared.getScrapDesigner { networkResult in
            switch networkResult {
            case .success(let responseData):
                if let result = responseData as? GetScrapDesignerResponseDTO {
                    completion(result.toBrowseDesignerScrapEntity())
                }
            default:
                self.showNetworkErrorAlert()
            }
            self.stopActivityIndicator()
        }
    }
}

// MARK: - UI

extension BrowseScrapViewController {
    private func setLayout() {
        self.view.addSubviews([collectionView])
        
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
