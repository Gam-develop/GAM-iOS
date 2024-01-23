//
//  SecessionViewController.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/23/24.
//

import UIKit
import RxSwift
import SnapKit

final class SecessionViewController: BaseViewController {
    
    // MARK: Properties
    
    private let viewModel: SecessionViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let navigationView: GamNavigationView = {
        let view = GamNavigationView(type: .backTitle)
        view.setCenterTitle("탈퇴하기")
        return view
    }()
    
    private let titleLabel = GamSingleLineLabel(text: "주현님 좋은 영감을 주셔서 감사했어요",
                                                font: .subhead4Bold,
                                                color: .black)
    
    private let subTitleLabel = GamSingleLineLabel(text: "감을 떠나시는 이유가 궁금해요.",
                                               font: .caption2Regular,
                                                color: .gamBlack)
    
    private let reasonTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .gamGray1
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.sectionHeaderTopPadding = 0
        view.bounces = false
        view.rowHeight = UITableView.automaticDimension
        view.register(cell: SecessionTableViewCell.self, forCellReuseIdentifier: SecessionTableViewCell.className)
        return view
    }()
    
    private let buttonInfoLabel = GamSingleLineLabel(text: "개인정보는 3주 뒤에 사라질 예정입니다.",
                                                     font: .caption2Regular,
                                                     color: .gamGray3)
    
    private let confirmButton: GamFullButton = {
        let button = GamFullButton(type: .system)
        button.setTitle("탈퇴하기", for: .normal)
        return button
    }()
    
    // MARK: Life Cycle
    
    init(viewModel: SecessionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    override func viewDidLoad() {
        self.setUI()
        self.setLayout()
        self.setBackButtonAction(self.navigationView.backButton)
        self.setTableView()
        self.bind()
    }
}

// MARK: - Methods

extension SecessionViewController {
    
    private func setTableView() {
        let reasons = [
            "매거진 컨텐츠가 유익하지 않아요.",
            "매거진 발행 주기가 늦어요.",
            "포트폴리오에서 영감을 얻지 못했어요.",
            "앱 오류가 자주 발생해요.",
            "직접 입력할게요."
        ]
        
        let reasonsObservable: Observable<[String]> = Observable.of(reasons)
        
        reasonsObservable
            .bind(to: self.reasonTableView.rx.items(cellIdentifier: SecessionTableViewCell.className, cellType: SecessionTableViewCell.self)) { (index: Int, element: String, cell: SecessionTableViewCell) in
                cell.setReasonLabel(element)
                
                cell.checkboxTap
                    .asDriver()
                    .drive(with: self, onNext: { owner, _ in
                        let isSelected = cell.setSelectedState()
                        
                        var currentSelectedItems = self.viewModel.selectedItems.value
                        if isSelected {
                            currentSelectedItems.append(index)
                        } else {
                            currentSelectedItems.removeAll { $0 == index }
                        }
                        self.viewModel.selectedItems.accept(currentSelectedItems)
                        
                        if element == reasons.last{
                            if isSelected {
                                debugPrint("직접 입력하는 창 떠야됨")
                            } else {
                                debugPrint("직접 입력하는 창 꺼야됨")
                            }
                        }
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        Observable.just(54)
            .bind(to: self.reasonTableView.rx.rowHeight)
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        self.viewModel.selectedItems
            .map { $0.count > 0 }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, buttonEnable in
                owner.confirmButton.isEnabled = buttonEnable
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI

extension SecessionViewController {
    
    private func setUI() {
        self.view.backgroundColor = .gamGray1
    }
    
    private func setLayout() {
        self.view.addSubviews([navigationView, titleLabel, subTitleLabel, reasonTableView, buttonInfoLabel, confirmButton])
        
        self.navigationView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(23)
        }
        
        self.subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().inset(23)
        }
        
        self.reasonTableView.snp.makeConstraints { make in
            make.top.equalTo(self.subTitleLabel.snp.bottom).offset(17)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.buttonInfoLabel.snp.top).offset(-17)
        }
        
        self.buttonInfoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.confirmButton.snp.top).offset(-10)
        }
        
        self.confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
    }
}

