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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchData()
    }
    
    // MARK: Methods
    
    private func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(MagazineScrapTableHeaderView.self, forHeaderFooterViewReuseIdentifier: MagazineScrapTableHeaderView.className)
        self.tableView.register(cell: MagazineTableViewCell.self)
    }
    
    private func fetchData() {
        self.getScrapMagazine { magazines in
            self.magazines = magazines
            self.tableView.reloadData()
        }
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
                self?.requestScrapMagazine(data: .init(targetMagazineId: self?.magazines[indexPath.row].id ?? 0, currentScrapStatus: bool)) {
                    cell.scrapButton.isSelected = !bool
                    self?.fetchData()
                }
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

// MARK: - Network

extension MagazineScrapViewController {
    private func getScrapMagazine(completion: @escaping ([MagazineEntity]) -> ()) {
        self.startActivityIndicator()
        MagazineService.shared.getScrapMagazine { networkResult in
            switch networkResult {
            case .success(let responseData):
                if let result = responseData as? ScrapMagazineResponseDTO {
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

extension MagazineScrapViewController {
    private func setLayout() {
        self.view.addSubview(tableView)
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
