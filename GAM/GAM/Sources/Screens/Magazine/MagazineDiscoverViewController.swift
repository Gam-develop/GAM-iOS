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
    private var magazines: [MagazineEntity] = []
    
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
        self.fetchData()
        self.setRefreshControl()
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
    
    private func fetchData() {
        self.getAllMagazine { magazines in
            self.magazines = magazines
            self.tableView.reloadData()
        }
    }
    
    private func setRefreshControl() {
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(target, action: #selector(self.handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        self.fetchData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.tableView.refreshControl?.endRefreshing()
        }
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
            case .recent:
                if self.magazines.count > 1 {
                    return 1
                } else { return 0}
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
                        self?.requestScrapMagazine(data: .init(targetMagazineId: self?.magazines[indexPath.row].id ?? 0, currentScrapStatus: bool)) {
                            cell.scrapButton.isSelected = !bool
                            self?.fetchData()
                        }
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
                
                if self.magazines.count > 1 {
                    view.setData(data: self.magazines[0])
                }
                
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

// MARK: - Network

extension MagazineDiscoverViewController {
    private func getAllMagazine(completion: @escaping ([MagazineEntity]) -> ()) {
        self.startActivityIndicator()
        MagazineService.shared.getAllMagazine { networkResult in
            switch networkResult {
            case .success(let responseData):
                if let result = responseData as? MagazineResponseDTO {
                    completion(result.toMagazineEntity())
                }
            default:
                self.showNetworkErrorAlert()
            }
            self.stopActivityIndicator()
        }
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
