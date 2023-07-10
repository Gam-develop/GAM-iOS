//
//  SearchViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/10.
//

import UIKit
import SnapKit

final class SearchViewController: BaseViewController {
    
    enum Section: CaseIterable {
        case recent
    }
    
    enum SearchType {
        case magazine
        case portfolio
    }
    
    enum Text {
        static let recentSearchTitle = "최근 검색"
        static let recentClear = "전체 삭제"
    }
    
    // MARK: UIComponents
    
    private let navigationView: GamNavigationView = GamNavigationView(type: .back)
    private let searchTextField: GamSearchTextField = GamSearchTextField()
    
    private let recentSearchTitle: UILabel = {
        let label: UILabel = UILabel()
        label.setTextWithStyle(to: Text.recentSearchTitle, style: .subhead3SemiBold, color: .gamBlack)
        return label
    }()
    
    private let recentClearButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setTitle(Text.recentClear, for: .normal)
        button.titleLabel?.font = .caption1Regular
        button.setTitleColor(.gamBlack, for: .normal)
        return button
    }()
    
    private let recentSearchTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.rowHeight = 44
        tableView.register(cell: RecentSearchTableViewCell.self)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: Properties
    
    private var searchType: SearchType = .magazine
    private var recentSearchDataSource: UITableViewDiffableDataSource<Section, RecentSearchEntity>!
    private var recentSearchSnapshot: NSDiffableDataSourceSnapshot<Section, RecentSearchEntity>!
    
    private var recentSearchData: [RecentSearchEntity] = []
    
    // MARK: Initializer
    
    init(searchType: SearchType) {
        super.init(nibName: nil, bundle: nil)
        
        self.searchType = searchType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.setBackButtonAction(self.navigationView.backButton)
        self.setSearchTextField()
        self.setRecentClearButtonAction()
        self.fetchRecentSearchData()
        self.setRecentSearchTableView()
        self.setRecentSearchSnapshot()
    }
    
    // MARK: Methods
    
    private func setSearchTextField() {
        self.searchTextField.delegate = self
    }
    
    private func setRecentClearButtonAction() {
        self.recentClearButton.setAction { [weak self] in
            RecentSearchEntity.setUserDefaults(data: [], forKey: UserDefaults.Keys.recentSearch)
            self?.fetchRecentSearchData()
            self?.setRecentSearchSnapshot()
        }
    }
}

// MARK: - Recent Search

extension SearchViewController {
    private func fetchRecentSearchData() {
        if let localData = RecentSearchEntity.getUserDefaults(forKey: .recentSearch) {
            self.recentSearchData = localData.reversed()
        } else {
            RecentSearchEntity.setUserDefaults(data: [], forKey: .recentSearch)
            self.fetchRecentSearchData()
        }
    }
    
    private func setRecentSearchTableView() {
        self.recentSearchTableView.delegate = self
        
        self.recentSearchDataSource = UITableViewDiffableDataSource<Section, RecentSearchEntity>(
            tableView: self.recentSearchTableView,
            cellProvider: { tableView, indexPath, _ in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: RecentSearchTableViewCell.className,
                    for: indexPath
                ) as? RecentSearchTableViewCell else { return UITableViewCell() }
                cell.setData(data: self.recentSearchData[indexPath.row])
                return cell
            })
        self.recentSearchDataSource.defaultRowAnimation = .automatic
        self.recentSearchTableView.dataSource = self.recentSearchDataSource
    }
    
    private func setRecentSearchSnapshot() {
        self.recentSearchSnapshot = NSDiffableDataSourceSnapshot<Section, RecentSearchEntity>()
        self.recentSearchSnapshot.appendSections([.recent])
        self.recentSearchSnapshot.appendItems(self.recentSearchData)
        self.recentSearchDataSource.apply(self.recentSearchSnapshot)
    }
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let keyword = textField.text?.trimmingCharacters(in: .whitespaces), keyword.count > 0 {
            
            self.recentSearchData.reverse()
            
            /// 중복 제거
            
            if let duplicatedIndex = self.recentSearchData.firstIndex(where: { $0.title == keyword }) {
                self.recentSearchData.remove(at: duplicatedIndex)
            }
            
            self.recentSearchData.append(RecentSearchEntity(id: Date().hashValue, title: keyword))
            RecentSearchEntity.setUserDefaults(data: self.recentSearchData, forKey: .recentSearch)
        }
        
        self.fetchRecentSearchData()
        self.setRecentSearchSnapshot()
        return true
    }
}

// MARK: - UI

extension SearchViewController {
    private func setLayout() {
        self.view.addSubviews([navigationView, searchTextField, recentSearchTitle, recentClearButton, recentSearchTableView])
        
        self.navigationView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.searchTextField.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        self.recentSearchTitle.snp.makeConstraints { make in
            make.top.equalTo(self.searchTextField.snp.bottom).offset(32)
            make.left.equalToSuperview().inset(22)
            make.height.equalTo(27)
        }
        
        self.recentClearButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.recentSearchTitle)
            make.right.equalToSuperview().inset(20)
        }
        
        self.recentSearchTableView.snp.makeConstraints { make in
            make.top.equalTo(self.recentSearchTitle.snp.bottom).offset(12)
            make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    }
}
