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
        static let designerCellHeight = 268
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
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layoutMargins = .zero
        return collectionView
    }()
    
    // MARK: Properties
    
    private var magazines: [MagazineEntity] = [
        MagazineEntity(id: 0, thumbnailImage: .defaultImage, title: "어쩌\n구", author: "김형우", isScrap: true, url: "www.naver.com", visibilityCount: 13),
        MagazineEntity(id: 0, thumbnailImage: .defaultImage, title: "어쩌\n구\n안뇽", author: "디자이너", isScrap: false, url: "www.daum.com", visibilityCount: 1234),
        MagazineEntity(id: 0, thumbnailImage: .defaultImage, title: "어쩌\n구", author: "김형우", isScrap: true, url: "www.naver.com", visibilityCount: 1)
    ]
    
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
        
    }
}

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

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("selected \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

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
