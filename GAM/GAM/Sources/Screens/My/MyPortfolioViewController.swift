//
//  MyPortfolioViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/08/02.
//

import UIKit
import SnapKit

final class MyPortfolioViewController: BaseViewController {
    
    private enum Number {
        static let portfolioCellHeight = 561.0
    }
    
    private enum Text {
        static let addProject = "프로젝트 추가하기"
        static let addContactURL = "링크 추가하기"
    }
    
    // MARK: UIComponents
    
    private let portfolioTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .init(), style: .grouped)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = Number.portfolioCellHeight
        tableView.separatorStyle = .none
        tableView.register(cell: MyPortfolioTableViewCell.self)
        tableView.register(cell: AddPortfolioTableViewCell.self)
        tableView.register(PortfolioTableFooterView.self, forHeaderFooterViewReuseIdentifier: PortfolioTableFooterView.className)
        return tableView
    }()
    
    private let emptyView: GamEmptyView = GamEmptyView(type: .myProject)
    
    // MARK: Properties
    
    private var superViewController: MyViewController?
    private var portfolio: UserPortfolioEntity = .init(
        id: 1,
        behanceURL: "",
        instagramURL: "",
        notionURL: "",
        projects: []
    )
    
    // MARK: Initializer
    
    init(superViewController: MyViewController) {
        super.init(nibName: nil, bundle: nil)
        
        self.superViewController = superViewController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchData()
        self.setLayout()
        self.setPortfolioTableView()
        self.setAddProjectButtonAction()
    }
    
    // MARK: Methods
    
    private func fetchData() {
        self.getPortfolio { portfolio in
            DispatchQueue.main.async {
                self.portfolio = portfolio
                self.portfolioTableView.reloadData()
                self.setEmptyView()
            }
        }
    }
    
    private func setPortfolioTableView() {
        self.portfolioTableView.dataSource = self
        self.portfolioTableView.delegate = self
    }
    
    private func setAddProjectButtonAction() {
        self.emptyView.button.setAction { [weak self] in
            self?.navigationController?.pushViewController(BaseViewController(), animated: true, completion: nil)
        }
    }
    
    private func openEditActionSheet(row: Int, project: ProjectEntity) {
        let actionSheet: UIAlertController = UIAlertController(
            title: nil,
            message: project.title,
            preferredStyle: .actionSheet
        )
        
        if row != 0 {
            actionSheet.addAction(
                UIAlertAction(
                    title: "대표 프로젝트로 설정",
                    style: .default,
                    handler: { _ in
                        self.setRepPortfolio(workId: project.id) {
                            self.fetchData()
                            self.portfolioTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                        }
                    }
                )
            )
        }
    
        actionSheet.addAction(
            UIAlertAction(
                title: "수정하기",
                style: .default,
                handler: { _ in
                    // TODO: 수정하기 request
                    self.superViewController?.navigationController?.pushViewController(BaseViewController(), animated: true, completion: nil)
                }
            )
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "삭제하기",
                style: .destructive,
                handler: { _ in
                    self.makeAlertWithCancel(title: project.title, message: "프로젝트를 삭제하시겠습니까?", okTitle: "삭제하기", okStyle: .destructive) { _ in
                        self.deletePortfolio(workId: project.id) {
                            self.fetchData()
                        }
                    }
                }
            )
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "취소",
                style: .cancel,
                handler: nil
            )
        )
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension MyPortfolioViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.portfolio.projects.count {
        case 0: return 0
        case 1, 2: return 2
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.portfolio.projects.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withType: MyPortfolioTableViewCell.self, for: indexPath)
            
            cell.repView.isHidden = indexPath.row != 0
            cell.setData(data: self.portfolio.projects[indexPath.row])
            cell.moreButton.removeTarget(nil, action: nil, for: .allTouchEvents)
            cell.moreButton.setAction { [weak self] in
                if let project = self?.portfolio.projects[indexPath.row] {
                    self?.openEditActionSheet(row: indexPath.row, project: project)
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withType: AddPortfolioTableViewCell.self, for: indexPath)
            cell.addProjectButton.setAction { [weak self] in
                let addProjectViewController = AddProjectViewController()
                addProjectViewController.sendUpdateDelegate = self
                self?.navigationController?.pushViewController(addProjectViewController, animated: true, completion: nil)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (self.portfolio.projects.count <= 2 && section == 1) || (self.portfolio.projects.count == 3) {
            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: PortfolioTableFooterView.className) as? PortfolioTableFooterView
            else { return UIView() }
            view.setTitle(title: Text.addContactURL)
            
            view.setButtonState(
                behance: self.portfolio.behanceURL,
                instagram: self.portfolio.instagramURL,
                notion: self.portfolio.notionURL
            )
            
            view.behanceButton.removeTarget(nil, action: nil, for: .allTouchEvents)
            view.notionButton.removeTarget(nil, action: nil, for: .allTouchEvents)
            view.instagramButton.removeTarget(nil, action: nil, for: .allTouchEvents)
            
            view.behanceButton.setAction { [weak self] in
                let addContactURLViewController = AddContactURLViewController(
                    type: .behance,
                    url: self?.portfolio.behanceURL ?? ""
                )
                addContactURLViewController.sendUpdateDelegate = self
                self?.navigationController?.pushViewController(
                    addContactURLViewController, animated: true, completion: nil)
            }
            
            view.instagramButton.setAction { [weak self] in
                let addContactURLViewController = AddContactURLViewController(
                    type: .instagram,
                    url: self?.portfolio.instagramURL ?? ""
                )
                addContactURLViewController.sendUpdateDelegate = self
                self?.navigationController?.pushViewController(
                    addContactURLViewController, animated: true, completion: nil)
            }
            
            view.notionButton.setAction { [weak self] in
                let addContactURLViewController = AddContactURLViewController(
                    type: .notion,
                    url: self?.portfolio.notionURL ?? ""
                )
                addContactURLViewController.sendUpdateDelegate = self
                self?.navigationController?.pushViewController(
                    addContactURLViewController, animated: true, completion: nil)
            }
            
            return view
        }
        return nil
    }
}

// MARK: - UITableViewDelegate

extension MyPortfolioViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == 1) || (section == 0 && self.portfolio.projects.count == 3) {
            return 169 + 40
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 92
        } else {
            return UITableView.automaticDimension
        }
    }
}

// MARK: - SendUpdateDelegate

extension MyPortfolioViewController: SendUpdateDelegate {
    
    func sendUpdate(data: Any?) {
        self.fetchData()
        if let scrollToTop = data as? Bool, scrollToTop {
            self.portfolioTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}

// MARK: - Network

extension MyPortfolioViewController {
    private func getPortfolio(completion: @escaping (UserPortfolioEntity) -> ()) {
        self.startActivityIndicator()
        MypageService.shared.getPortfolio { networkResult in
            switch networkResult {
            case .success(let responseData):
                if let result = responseData as? PortfolioResponseDTO {
                    completion(result.toUserPortfolioEntity())
                }
            default:
                self.showNetworkErrorAlert()
            }
            self.stopActivityIndicator()
        }
    }
    
    private func setRepPortfolio(workId: Int, completion: @escaping () -> ()) {
        self.startActivityIndicator()
        MypageService.shared.setRepPortfolio(data: SetPortfolioRequestDTO(workId: workId)) { networkResult in
            switch networkResult {
            case .success(_):
                completion()
            default:
                self.showNetworkErrorAlert()
            }
            self.stopActivityIndicator()
        }
    }
    
    private func deletePortfolio(workId: Int, completion: @escaping () -> ()) {
        self.startActivityIndicator()
        MypageService.shared.deletePortfolio(data: SetPortfolioRequestDTO(workId: workId)) { networkResult in
            switch networkResult {
            case .success(_):
                completion()
            default:
                self.showNetworkErrorAlert()
            }
            self.stopActivityIndicator()
        }
    }
}


// MARK: - UI

extension MyPortfolioViewController {
    private func setLayout() {
        self.view.addSubviews([portfolioTableView, emptyView])
        
        self.portfolioTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.emptyView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(48)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(279)
        }
    }
    
    private func setEmptyView() {
        self.emptyView.isHidden = !self.portfolio.projects.isEmpty
        self.portfolioTableView.isHidden = self.portfolio.projects.isEmpty
    }
}
