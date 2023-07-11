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
    
    // MARK: Properties
    
    private var searchType: SearchType = .magazine
    private var recentSearchDataSource: UITableViewDiffableDataSource<Section, RecentSearchEntity>!
    private var recentSearchSnapshot: NSDiffableDataSourceSnapshot<Section, RecentSearchEntity>!
    
    var magazineSearchResultDataSource: UITableViewDiffableDataSource<Section, MagazineEntity>!
    var magazineSearchResultSnapshot: NSDiffableDataSourceSnapshot<Section, MagazineEntity>!
    
    private var recentSearchData: [RecentSearchEntity] = []
    private var magazineSearchResultData: [MagazineEntity] = [
        MagazineEntity(id: 0, thumbnailImageURL: "", title: "졸업 작품이\n전세계적인 주목을\n받았다고?", author: "김형우", isScrap: true, url: "https://www.naver.com", visibilityCount: 13),
        MagazineEntity(id: 0, thumbnailImageURL: "", title: "졸업 작품이\n전세계적인 주목을\n받았다고?", author: "이용택", isScrap: false, url: "https://www.daum.net", visibilityCount: 1234),
        MagazineEntity(id: 0, thumbnailImageURL: "", title: "어쩌\n구", author: "김형우", isScrap: true, url: "https://www.naver.com", visibilityCount: 17),
        MagazineEntity(id: 0, thumbnailImageURL: "", title: "어쩌\n구", author: "김형우", isScrap: true, url: "https://www.naver.com", visibilityCount: 2),
        MagazineEntity(id: 0, thumbnailImageURL: "", title: "어쩌\n구", author: "김형우", isScrap: true, url: "https://www.naver.com", visibilityCount: 3),
        MagazineEntity(id: 0, thumbnailImageURL: "", title: "어쩌\n구", author: "김형우", isScrap: true, url: "https://www.naver.com", visibilityCount: 1)
    ]
    
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
        case .portfolio: break
        }
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
                    RecentSearchEntity.setUserDefaults(data: self?.recentSearchData.reversed() ?? [], forKey: .recentSearch)
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
        self.searchMagazine(keyword: sender.keyword)
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
    }
    
    private func setMagazineSearchResultSnapshot() {
        self.magazineSearchResultSnapshot = NSDiffableDataSourceSnapshot<Section, MagazineEntity>()
        self.magazineSearchResultSnapshot.appendSections([.recent])
        self.magazineSearchResultSnapshot.appendItems(self.magazineSearchResultData)
        self.magazineSearchResultDataSource.apply(self.magazineSearchResultSnapshot)
    }
    
    private func searchMagazine(keyword: String?) {
        if let keyword = keyword?.trimmingCharacters(in: .whitespaces), keyword.count > 0 {
            self.magazineSearchResultTableView.isHidden = false
            self.setMagazineSearchResultTableView(keyword: keyword)
            self.setMagazineSearchResultSnapshot()
            
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
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.magazineSearchResultTableView {
            let magazineDetailViewController: MagazineDetailViewController = MagazineDetailViewController(url: self.magazineSearchResultData[indexPath.row].url)
            self.navigationController?.pushViewController(magazineDetailViewController, animated: true)
        }
    }
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchMagazine(keyword: textField.text)
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
    
    private func setMagazineSearchResultLayout() {
        self.view.addSubviews([magazineSearchResultTableView])
        
        self.magazineSearchResultTableView.snp.makeConstraints { make in
            make.top.equalTo(self.searchTextField.snp.bottom).offset(27)
            make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
