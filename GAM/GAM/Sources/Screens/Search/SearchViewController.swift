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
    
    enum Number {
        static let magazineCellHeight = 140.0
        static let magazineCellSpacing = 18.0
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
    
    private let magazineSearchResultTableView: MagazineTableView = MagazineTableView(cellType: .noScrap)
    private let portfolioSearchResultTableView: MagazineTableView = MagazineTableView(cellType: .noScrap)
    
    private let emptyView: GamEmptyView = GamEmptyView(type: .noSearchResult)
    
    // MARK: Properties
    
    private var searchType: SearchType = .magazine
    private var recentSearchDataSource: UITableViewDiffableDataSource<Section, RecentSearchEntity>!
    private var recentSearchSnapshot: NSDiffableDataSourceSnapshot<Section, RecentSearchEntity>!
    
    var magazineSearchResultDataSource: UITableViewDiffableDataSource<Section, MagazineEntity>!
    var magazineSearchResultSnapshot: NSDiffableDataSourceSnapshot<Section, MagazineEntity>!
    var portfolioSearchResultDataSource: UITableViewDiffableDataSource<Section, PortfolioSearchEntity>!
    var portfolioSearchResultSnapshot: NSDiffableDataSourceSnapshot<Section, PortfolioSearchEntity>!
    
    private var recentSearchData: [RecentSearchEntity] = []
    private var magazineSearchResultData: [MagazineEntity] = []
    private var portfolioSearchResultData: [PortfolioSearchEntity] = []
    
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
        switch self.searchType {
        case .magazine :
            self.magazineSearchResultTableView.isHidden = true
            self.setMagazineSearchResultLayout()
        case .portfolio:
            self.portfolioSearchResultTableView.isHidden = true
            self.setPortfolioSearchResultLayout()
        }
        self.setEmptyViewLayout()
        self.setEmptyViewVisibility(isOn: false)
    }
    
    // MARK: Methods
    
    private func setSearchTextField() {
        self.searchTextField.delegate = self
    }
    
    private func setRecentClearButtonAction() {
        self.recentClearButton.setAction { [weak self] in
            RecentSearchEntity.setUserDefaults(data: [], forKey: self?.searchType == .magazine ? .recentMagazineSearch : .recentPortfolioSearch)
            self?.fetchRecentSearchData()
            self?.setRecentSearchSnapshot()
        }
    }
    
    private func setEmptyViewVisibility(isOn: Bool) {
        self.emptyView.isHidden = !isOn
    }
    
    private func setSearchResultData(searchType: SearchType, keyword: String) {
        switch searchType {
        case .magazine:
            self.magazineSearchResultTableView.isHidden = false
            self.setMagazineSearchResultTableView(keyword: keyword)
            self.setMagazineSearchResultSnapshot()
        case .portfolio:
            self.portfolioSearchResultTableView.isHidden = false
            self.setPortfolioSearchResultTableView(keyword: keyword)
            self.setPortfolioSearchResultSnapshot()
        }
    }
}

// MARK: - Recent Search

extension SearchViewController {
    private func fetchRecentSearchData() {
        if let localData = RecentSearchEntity.getUserDefaults(forKey: self.searchType == .magazine ? .recentMagazineSearch : .recentPortfolioSearch) {
            self.recentSearchData = localData.reversed()
        } else {
            RecentSearchEntity.setUserDefaults(data: [], forKey: self.searchType == .magazine ? .recentMagazineSearch : .recentPortfolioSearch)
            self.fetchRecentSearchData()
        }
    }
    
    private func setRecentSearchTableView() {
        self.recentSearchDataSource = UITableViewDiffableDataSource<Section, RecentSearchEntity>(
            tableView: self.recentSearchTableView,
            cellProvider: { tableView, indexPath, _ in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: RecentSearchTableViewCell.className,
                    for: indexPath
                ) as? RecentSearchTableViewCell else { return UITableViewCell() }
                cell.setData(data: self.recentSearchData[indexPath.row])
                
                let recognizer = RecentSearchTapGestureRecognizer(target: self, action: #selector(self.recentSearchKeywordTapped(_:)))
                cell.contentView.removeGestureRecognizer(recognizer)
                recognizer.keyword = self.recentSearchData[indexPath.row].title
                cell.contentView.addGestureRecognizer(recognizer)
                
                cell.removeButton.removeTarget(nil, action: nil, for: .allTouchEvents)
                cell.removeButton.setAction { [weak self] in
                    self?.recentSearchData.remove(at: indexPath.row)
                    RecentSearchEntity.setUserDefaults(data: self?.recentSearchData.reversed() ?? [], forKey: self?.searchType == .magazine ? .recentMagazineSearch : .recentPortfolioSearch)
                    self?.fetchRecentSearchData()
                    self?.setRecentSearchTableView()
                    self?.setRecentSearchSnapshot()
                }
                
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
    
    @objc
    private func recentSearchKeywordTapped(_ sender: RecentSearchTapGestureRecognizer) {
        self.searchTextField.endEditing(true)
        self.searchTextField.text = sender.keyword
        switch self.searchType {
        case .magazine:
            self.requestSearchMagazine(data: sender.keyword) { result in
                self.magazineSearchResultData = result
                self.setSearchResultData(searchType: self.searchType, keyword: sender.keyword)
            }
        case .portfolio:
            self.requestSearchDesigner(data: sender.keyword) { result in
                self.portfolioSearchResultData = result
                self.setSearchResultData(searchType: self.searchType, keyword: sender.keyword)
            }
        }
    }
}

// MARK: - Magazine Search

extension SearchViewController {
    private func setMagazineSearchResultTableView(keyword: String) {
        self.magazineSearchResultTableView.backgroundColor = .gamGray1
        self.magazineSearchResultTableView.delegate = self
        
        self.magazineSearchResultDataSource = UITableViewDiffableDataSource<Section, MagazineEntity>(
            tableView: self.magazineSearchResultTableView,
            cellProvider: { tableView, indexPath, _ in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: NoScrapMagazineTableViewCell.className,
                    for: indexPath
                ) as? NoScrapMagazineTableViewCell else { return UITableViewCell() }
                cell.setData(data: self.magazineSearchResultData[indexPath.row], keyword: keyword)
                return cell
            })
        self.magazineSearchResultDataSource.defaultRowAnimation = .automatic
        self.magazineSearchResultTableView.dataSource = self.magazineSearchResultDataSource
        self.setEmptyViewVisibility(isOn: self.magazineSearchResultData.count == 0)
    }
    
    private func setMagazineSearchResultSnapshot() {
        self.magazineSearchResultSnapshot = NSDiffableDataSourceSnapshot<Section, MagazineEntity>()
        self.magazineSearchResultSnapshot.appendSections([.recent])
        self.magazineSearchResultSnapshot.appendItems(self.magazineSearchResultData)
        self.magazineSearchResultDataSource.apply(self.magazineSearchResultSnapshot)
    }
    
    private func setRecentSearchMagazine(keyword: String) {
        if self.recentSearchData.count >= 8 {
            self.recentSearchData.removeLast()
        }
        
        self.recentSearchData.reverse()
        if let duplicatedIndex = self.recentSearchData.firstIndex(where: { $0.title == keyword }) {
            self.recentSearchData.remove(at: duplicatedIndex)
        }
        
        self.recentSearchData.append(RecentSearchEntity(id: Date().hashValue, title: keyword))
        RecentSearchEntity.setUserDefaults(data: self.recentSearchData, forKey: .recentMagazineSearch)
        
        self.fetchRecentSearchData()
        self.setRecentSearchTableView()
        self.setRecentSearchSnapshot()
    }
}

// MARK: - Portfolio Search

extension SearchViewController {
    private func setPortfolioSearchResultTableView(keyword: String) {
        self.portfolioSearchResultTableView.backgroundColor = .gamGray1
        self.portfolioSearchResultTableView.delegate = self
        
        self.portfolioSearchResultDataSource = UITableViewDiffableDataSource<Section, PortfolioSearchEntity>(
            tableView: self.portfolioSearchResultTableView,
            cellProvider: { tableView, indexPath, _ in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: NoScrapMagazineTableViewCell.className,
                    for: indexPath
                ) as? NoScrapMagazineTableViewCell else { return UITableViewCell() }
                cell.setData(data: self.portfolioSearchResultData[indexPath.row], keyword: keyword)
                return cell
            })
        self.portfolioSearchResultDataSource.defaultRowAnimation = .automatic
        self.portfolioSearchResultTableView.dataSource = self.portfolioSearchResultDataSource
        self.setEmptyViewVisibility(isOn: self.portfolioSearchResultData.count == 0)
    }
    
    private func setPortfolioSearchResultSnapshot() {
        self.portfolioSearchResultSnapshot = NSDiffableDataSourceSnapshot<Section, PortfolioSearchEntity>()
        self.portfolioSearchResultSnapshot.appendSections([.recent])
        self.portfolioSearchResultSnapshot.appendItems(self.portfolioSearchResultData)
        self.portfolioSearchResultDataSource.apply(self.portfolioSearchResultSnapshot)
    }
    
    private func setRecentSearchPortfolio(keyword: String) {
        if self.recentSearchData.count >= 8 {
            self.recentSearchData.removeLast()
        }
        
        self.recentSearchData.reverse()
        if let duplicatedIndex = self.recentSearchData.firstIndex(where: { $0.title == keyword }) {
            self.recentSearchData.remove(at: duplicatedIndex)
        }
        
        self.recentSearchData.append(RecentSearchEntity(id: Date().hashValue, title: keyword))
        RecentSearchEntity.setUserDefaults(data: self.recentSearchData, forKey: .recentPortfolioSearch)
        
        self.fetchRecentSearchData()
        self.setRecentSearchTableView()
        self.setRecentSearchSnapshot()
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.magazineSearchResultTableView {
            let magazineDetailViewController: MagazineDetailViewController = MagazineDetailViewController(url: self.magazineSearchResultData[indexPath.row].url)
            self.navigationController?.pushViewController(magazineDetailViewController, animated: true)
        } else {
            let portfolioDetailViewController: BaseViewController = UserViewController(userID: self.portfolioSearchResultData[indexPath.row].userId)
            self.navigationController?.pushViewController(portfolioDetailViewController, animated: true)
        }
    }
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let keyword = textField.text?.trimmingCharacters(in: .whitespaces), keyword.count > 0 {
            switch self.searchType {
            case .magazine:
                self.setRecentSearchMagazine(keyword: keyword)
                self.requestSearchMagazine(data: keyword) { result in
                    self.magazineSearchResultData = result
                    self.setSearchResultData(searchType: self.searchType, keyword: keyword)
                }
            case .portfolio:
                self.setRecentSearchPortfolio(keyword: keyword)
                self.requestSearchDesigner(data: keyword) { result in
                    self.portfolioSearchResultData = result
                    self.setSearchResultData(searchType: self.searchType, keyword: keyword)
                }
            }
        }
        
        return true
    }
}

// MARK: - Network

extension SearchViewController {
    private func requestSearchMagazine(data: String, completion: @escaping ([MagazineEntity]) -> ()) {
        self.startActivityIndicator()
        MagazineService.shared.searchMagazine(data: data) { networkResult in
            switch networkResult {
            case .success(let responseData):
                if let result = responseData as? SearchMagazineResponseDTO {
                    completion(result.toMagazineEntity())
                }
            default:
                self.showNetworkErrorAlert()
            }
            self.stopActivityIndicator()
        }
    }
    
    private func requestSearchDesigner(data: String, completion: @escaping ([PortfolioSearchEntity]) -> ()) {
        self.startActivityIndicator()
        DesignerService.shared.searchDesigner(data: data) { networkResult in
            switch networkResult {
            case .success(let responseData):
                if let result = responseData as? SearchDesignerResponseDTO {
                    completion(result.toPortfolioSearchEntity())
                }
            default:
                self.showNetworkErrorAlert()
            }
            self.stopActivityIndicator()
        }
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
    
    private func setMagazineSearchResultLayout() {
        self.view.addSubviews([magazineSearchResultTableView])
        
        self.magazineSearchResultTableView.snp.makeConstraints { make in
            make.top.equalTo(self.searchTextField.snp.bottom).offset(27)
            make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setPortfolioSearchResultLayout() {
        self.view.addSubviews([portfolioSearchResultTableView])
        
        self.portfolioSearchResultTableView.snp.makeConstraints { make in
            make.top.equalTo(self.searchTextField.snp.bottom).offset(27)
            make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setEmptyViewLayout() {
        self.view.addSubviews([emptyView])
        
        self.emptyView.snp.makeConstraints { make in
            make.top.equalTo(self.searchTextField.snp.bottom).offset(70)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(279)
        }
    }
}
