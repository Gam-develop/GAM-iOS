//
//  UserPortfolioViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/26.
//

import UIKit
import SnapKit

final class UserPortfolioViewController: BaseViewController {
    
    private enum Number {
        static let portfolioCellHeight = 561.0
    }
    
    private enum Text {
        static let goPortfolioTitle = "포트폴리오 보러가기"
    }
    
    // MARK: UIComponents
    
    private let portfolioTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .init(), style: .grouped)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Number.portfolioCellHeight
        tableView.separatorStyle = .none
        tableView.register(cell: PortfolioTableViewCell.self)
        tableView.register(PortfolioTableFooterView.self, forHeaderFooterViewReuseIdentifier: PortfolioTableFooterView.className)
        return tableView
    }()
    
    // MARK: Properties
    
    private var superViewController: UserViewController?
    private var portfolio: UserPortfolioEntity = .init(
        id: 1,
        behanceURL: "",
        instagramURL: "https://instagram.com/1v11aby",
        notionURL: "",
        works: [
            .init(id: 1, thumbnailImageURL: "", title: "L’ESPACE", detail: ""),
            .init(id: 2, thumbnailImageURL: "", title: "L’ESPACE", detail: "학교에서는 받는 교육 외에, 교외 팀플을 통해서 학교에서 받는 교육과 스타일을 깨고자 외부에서 프로젝트를."),
            .init(id: 3, thumbnailImageURL: "", title: "열두글자열두글자열두글자", detail: ""),
            .init(id: 3, thumbnailImageURL: "", title: "열두글자열두글자열두글자", detail: "오십글자오십글자오십글자오십글자오십글자오십글자오십글자오십글자오십글자오십글자오십글자오십글자오끝"),
            .init(id: 1, thumbnailImageURL: "", title: "L’ESPACE", detail: "")
        ]
    )
    
    // MARK: Initializer
    
    init(superViewController: UserViewController) {
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
        self.setPortfolioTableView()
    }
    
    // MARK: Methods
    
    private func setPortfolioTableView() {
        self.portfolioTableView.dataSource = self
        self.portfolioTableView.delegate = self
    }
}

// MARK: - UITableViewDataSource

extension UserPortfolioViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.portfolio.works.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withType: PortfolioTableViewCell.self, for: indexPath)
        
        cell.repView.isHidden = indexPath.row != 0
        cell.setData(data: self.portfolio.works[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: PortfolioTableFooterView.className) as? PortfolioTableFooterView
        else { return UIView() }
        view.setTitle(title: Text.goPortfolioTitle)
        
        view.setButtonState(
            behance: self.portfolio.behanceURL,
            instagram: self.portfolio.instagramURL,
            notion: self.portfolio.notionURL
        )
        
        view.behanceButton.setAction {
            self.openSafariInApp(url: self.portfolio.behanceURL)
        }
        
        view.instagramButton.setAction {
            self.openSafariInApp(url: self.portfolio.instagramURL)
        }
        
        view.notionButton.setAction {
            self.openSafariInApp(url: self.portfolio.notionURL)
        }
        
        return view
    }
}

// MARK: - UITableViewDelegate

extension UserPortfolioViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 169 + 40
    }
}

// MARK: - UI

extension UserPortfolioViewController {
    private func setLayout() {
        self.view.addSubviews([portfolioTableView])
        
        self.portfolioTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
