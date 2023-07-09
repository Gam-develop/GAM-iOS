//
//  HomeViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/06/30.
//

import UIKit

final class HomeViewController: BaseViewController {
    
    enum Text {
        static let magazineTitle = "영감 매거진"
        static let designerTitle = "감잡은 디자이너"
    }
    
    enum Number {
        static let magazineCellHeight = 140
        static let magazineCellSpacing = 18
        static let designerCellHeight = 268.0
        static let designerCellWidth = 180.0
        static let designerCellSpacing = 8.0
    }
    
    // MARK: UIComponents
    
    private let scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView: UIView = UIView()
    private let magazineTitleLabel: Headline1Label = Headline1Label(text: Text.magazineTitle)
    private let magazineTableView: MagazineTableView = MagazineTableView(cellType: .normal)
    private let designerTitleLabel: Headline1Label = Headline1Label(text: Text.designerTitle)
    
    private let designerCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = Number.designerCellSpacing
        flowLayout.itemSize = .init(width: Number.designerCellWidth, height: Number.designerCellHeight)
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layoutMargins = .zero
        collectionView.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        return collectionView
    }()
    
    // MARK: Properties
    
    private var magazines: [MagazineEntity] = [
        MagazineEntity(id: 0, thumbnailImageURL: "", title: "어쩌\n구", author: "김형우", isScrap: true, url: "www.naver.com", visibilityCount: 13),
        MagazineEntity(id: 0, thumbnailImageURL: "", title: "졸업 작품이\n전세계적인 주목을\n받았다고?", author: "이용택", isScrap: false, url: "www.daum.com", visibilityCount: 1234),
        MagazineEntity(id: 0, thumbnailImageURL: "", title: "어쩌\n구", author: "김형우", isScrap: true, url: "www.naver.com", visibilityCount: 1)
    ].shuffled()
    
    private var designers: [PopularDesignerEntity] = [
        PopularDesignerEntity(id: 0, thumbnailImageURL: "", name: "최가연", tags: [0, 1, 2], isScrap: true, visibilityCount: 12),
        PopularDesignerEntity(id: 1, thumbnailImageURL: "", name: "박경은", tags: [3], isScrap: false, visibilityCount: 12),
        PopularDesignerEntity(id: 2, thumbnailImageURL: "", name: "원종화", tags: [5, 7], isScrap: true, visibilityCount: 12),
        PopularDesignerEntity(id: 3, thumbnailImageURL: "", name: "정정빈", tags: [2], isScrap: false, visibilityCount: 12),
        PopularDesignerEntity(id: 4, thumbnailImageURL: "", name: "최가희", tags: [9, 10], isScrap: true, visibilityCount: 12)
    ].shuffled()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTableView()
        self.setCollectionView()
        self.setLayout()
    }
    
    // MARK: Methods
    
    private func setTableView() {
        self.magazineTableView.delegate = self
        self.magazineTableView.dataSource = self
    }
    
    private func setCollectionView() {
        self.designerCollectionView.delegate = self
        self.designerCollectionView.dataSource = self
        
        self.designerCollectionView.register(cell: PopularDesignerCollectionViewCell.self)
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MagazineTableViewCell.className, for: indexPath) as? MagazineTableViewCell
        else { return UITableViewCell() }
        
        cell.setData(data: self.magazines[indexPath.row])
        cell.scrapButton.removeTarget(nil, action: nil, for: .allTouchEvents)
        cell.scrapButton.setAction { [weak self] in
            if let bool = self?.magazines[indexPath.row].isScrap {
                debugPrint("스크랩 request")
                self?.magazines[indexPath.row].isScrap = !bool
                cell.scrapButton.isSelected = !bool
            }
        }
        return cell
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularDesignerCollectionViewCell.className, for: indexPath) as? PopularDesignerCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.setData(data: self.designers[indexPath.row])
        cell.scrapButton.removeTarget(nil, action: nil, for: .allTouchEvents)
        cell.scrapButton.setAction { [weak self] in
            if let bool = self?.magazines[indexPath.row].isScrap {
                debugPrint("스크랩 request")
                self?.magazines[indexPath.row].isScrap = !bool
                cell.scrapButton.isSelected = !bool
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("selected \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("selected \(indexPath.row)")
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - UI

extension HomeViewController {
    private func setLayout() {
        self.view.addSubviews([scrollView])
        self.scrollView.addSubviews([contentView])
        self.contentView.addSubviews([magazineTitleLabel, magazineTableView, designerTitleLabel, designerCollectionView])
        
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.magazineTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(26)
            make.horizontalEdges.equalToSuperview().inset(22)
            make.height.equalTo(30)
        }
        
        self.magazineTableView.snp.makeConstraints { make in
            make.top.equalTo(self.magazineTitleLabel.snp.bottom).offset(7)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(Number.magazineCellHeight * 3 + Number.magazineCellSpacing * 3)
        }
        
        self.designerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.magazineTableView.snp.bottom).offset(31)
            make.horizontalEdges.equalToSuperview().inset(22)
            make.height.equalTo(30)
        }
        
        self.designerCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.designerTitleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(Number.designerCellHeight)
            make.bottom.equalToSuperview().inset(29)
        }
        
        self.contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
    }
}
