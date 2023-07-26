//
//  MagazineScrapViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/10.
//

import UIKit
import SnapKit

final class MagazineScrapViewController: BaseViewController {
    
    private enum Number {
        static let headerHeight = 52.0
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
        
        self.tableView.register(MagazineScrapTableHeaderView.self, forHeaderFooterViewReuseIdentifier: MagazineScrapTableHeaderView.className)
        self.tableView.register(cell: MagazineTableViewCell.self)
    }
}

// MARK: - UITableViewDataSource

extension MagazineScrapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.magazines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: MagazineScrapTableHeaderView.className) as? MagazineScrapTableHeaderView
        else { return UIView() }
        view.setCount(count: self.magazines.count)
        return view
    }
}

extension MagazineScrapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let magazineDetailViewController: MagazineDetailViewController = MagazineDetailViewController(url: self.magazines[indexPath.row].url)
        self.navigationController?.pushViewController(magazineDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Number.magazineCellHeight + Number.magazineCellSpacing
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Number.headerHeight
    }
}

// MARK: - UI

extension MagazineScrapViewController {
    private func setLayout() {
        self.view.addSubview(tableView)
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
