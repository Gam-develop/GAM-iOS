//
//  MagazineDiscoverViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/09.
//

import UIKit
import SnapKit

final class MagazineDiscoverViewController: BaseViewController {
    
    enum TableSection: Int, CaseIterable {
        case recent
        case all
    }
    
    enum Number {
        static let recentHeaderHeight = 368.0
        static let allHeaderHeight = 79.0
        static let magazineCellHeight = 140.0
        static let magazineCellSpacing = 18.0
    }
    
    // MARK: UIComponents
    
    private let tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .init(), style: .grouped)
        tableView.backgroundColor = .clear
        tableView.layoutMargins = .zero
        tableView.sectionHeaderTopPadding = .zero
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.sectionFooterHeight = .zero
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: Properties
    
    private var superViewController: MagazineViewController?
    private var magazines: [MagazineEntity] = [
        MagazineEntity(id: 0, thumbnailImageURL: "", title: "졸업 작품이\n전세계적인 주목을\n받았다고?", author: "김형우", isScrap: true, url: "https://www.naver.com", visibilityCount: 13),
        MagazineEntity(id: 0, thumbnailImageURL: "", title: "졸업 작품이\n전세계적인 주목을\n받았다고?", author: "이용택", isScrap: false, url: "https://www.daum.net", visibilityCount: 1234),
        MagazineEntity(id: 0, thumbnailImageURL: "", title: "어쩌\n구", author: "김형우", isScrap: true, url: "https://www.naver.com", visibilityCount: 17),
        MagazineEntity(id: 0, thumbnailImageURL: "", title: "어쩌\n구", author: "김형우", isScrap: true, url: "https://www.naver.com", visibilityCount: 2),
        MagazineEntity(id: 0, thumbnailImageURL: "", title: "어쩌\n구", author: "김형우", isScrap: true, url: "https://www.naver.com", visibilityCount: 3),
        MagazineEntity(id: 0, thumbnailImageURL: "", title: "어쩌\n구", author: "김형우", isScrap: true, url: "https://www.naver.com", visibilityCount: 1)
    ]
    
    // MARK: Initializer
    
    init(superViewController: MagazineViewController) {
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
        self.setTableView()
    }
    
    // MARK: Methods
    
    private func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(RecentMagazineTableHeaderView.self, forHeaderFooterViewReuseIdentifier: RecentMagazineTableHeaderView.className)
        self.tableView.register(AllMagazineTableHeaderView.self, forHeaderFooterViewReuseIdentifier: AllMagazineTableHeaderView.className)
        self.tableView.register(cell: MagazineTableViewCell.self)
    }
    
    @objc
    private func pushMagazineDetailViewController(_ sender: UITapGestureRecognizer) {
        let magazineDetailViewController: MagazineDetailViewController = MagazineDetailViewController(url: self.magazines[0].url)
        self.navigationController?.pushViewController(magazineDetailViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension MagazineDiscoverViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionType = TableSection(rawValue: section) {
            switch sectionType {
            case .recent: return 1
            case .all: return self.magazines.count
            }
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let sectionType = TableSection(rawValue: indexPath.section) {
            switch sectionType {
            case .recent: return UITableViewCell()
            case .all:
                let cell = tableView.dequeueReusableCell(withType: MagazineTableViewCell.self, for: indexPath)
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
        } else { return UITableViewCell() }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let sectionType = TableSection(rawValue: section) {
            switch sectionType {
            case .recent:
                guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecentMagazineTableHeaderView.className) as? RecentMagazineTableHeaderView
                else { return UIView() }
                view.setData(data: self.magazines[0])
                view.setAction(target: self, action: #selector(self.pushMagazineDetailViewController(_:)))
                return view
                
            case .all:
                guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: AllMagazineTableHeaderView.className) as? AllMagazineTableHeaderView
                else { return UIView() }
                return view
            }
        } else { return UIView() }
    }
}

extension MagazineDiscoverViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let magazineDetailViewController: MagazineDetailViewController = MagazineDetailViewController(url: self.magazines[indexPath.row].url)
        self.navigationController?.pushViewController(magazineDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let sectionType = TableSection(rawValue: indexPath.section) {
            switch sectionType {
            case .recent: return 0
            case .all: return Number.magazineCellHeight + Number.magazineCellSpacing
            }
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let sectionType = TableSection(rawValue: section) {
            switch sectionType {
            case .recent: return Number.recentHeaderHeight
            case .all: return Number.allHeaderHeight
            }
        } else { return 0 }
    }
}

// MARK: - UI

extension MagazineDiscoverViewController {
    private func setLayout() {
        self.view.addSubview(tableView)
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
