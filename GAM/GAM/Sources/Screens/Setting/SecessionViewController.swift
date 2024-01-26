//
//  SecessionViewController.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/23/24.
//

import UIKit
import RxSwift
import SnapKit
import RxGesture

final class SecessionViewController: BaseViewController {
    
    // MARK: Properties
    
    private let viewModel: SecessionViewModel
    private let disposeBag = DisposeBag()
    private let tapGesture = UITapGestureRecognizer()
    private let reasonCellHeight: CGFloat = 54.0
    
    private let reasons = [
        "매거진 컨텐츠가 유익하지 않아요.",
        "매거진 발행 주기가 늦어요.",
        "포트폴리오에서 영감을 얻지 못했어요.",
        "앱 오류가 자주 발생해요.",
        "직접 입력할게요."
    ]
    private let reasonTextVeiwPlaceholder = "다른 이유가 있으시면 말씀해주세요."
    
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
    
    private let reasonTextView: UITextView = {
        let view = UITextView()
        view.makeRounded(cornerRadius: 8)
        view.font = .caption2Regular
        view.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        view.isHidden = true
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
        let reasonsObservable: Observable<[String]> = Observable.of(self.reasons)
        
        reasonsObservable
            .bind(to: self.reasonTableView.rx.items(cellIdentifier: SecessionTableViewCell.className, cellType: SecessionTableViewCell.self)) { (index: Int, element: String, cell: SecessionTableViewCell) in
                cell.setReasonLabel(element)
                
                cell.checkboxTap
                    .asDriver()
                    .drive(with: self, onNext: { owner, _ in
                        let isSelected = cell.setSelectedState()
                        owner.viewModel.checkConfirmButtonState(index: index, isSelected: isSelected)
                        
                        // 직접 입력할게요 선택 시
                        if index == owner.reasons.index(before: owner.reasons.endIndex) {
                            owner.reasonTextView.isHidden = !isSelected
                        } else {
                            
                        }
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        Observable.just(reasonCellHeight)
            .bind(to: self.reasonTableView.rx.rowHeight)
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        self.viewModel.confirmButtonState
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, buttonEnable in
                owner.confirmButton.isEnabled = buttonEnable
            })
            .disposed(by: disposeBag)

        self.view.addGestureRecognizer(tapGesture)
        self.tapGesture.rx.event
            .bind(with: self, onNext: { owner, gesture in
                let location = gesture.location(in: owner.view)
                if !owner.reasonTextView.frame.contains(location) {
                    owner.view.endEditing(true)
                }
            })
            .disposed(by: self.disposeBag)
        
        self.reasonTextView.rx.text
            .map { $0?.trimmingCharacters(in: .whitespaces) ?? "" }
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, text in
                if owner.reasonTextView.textColor == .gamGray3 || text.isEmpty {
                    owner.viewModel.confirmButtonState.accept(false)
                } else {
                    owner.viewModel.confirmButtonState.accept(true)
                }
            })
            .disposed(by: self.disposeBag)
        
        self.reasonTextView.rx.didBeginEditing
            .bind(with: self, onNext: { owner, _ in
                if owner.reasonTextView.textColor == .gamGray3 {
                    owner.reasonTextView.text = nil
                    owner.reasonTextView.textColor = .gamBlack
                }
            }).disposed(by: self.disposeBag)

        self.reasonTextView.rx.didEndEditing
            .bind(with: self, onNext: { owner, _ in
                if owner.reasonTextView.text.isEmpty {
                    owner.setReasonTextViewUI()
            }}).disposed(by: self.disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .bind(with: self, onNext: { owner, notification in
                owner.adjustViewForKeyboard(didKeyboardShow: true)
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .bind(with: self, onNext: { owner, notification in
                owner.adjustViewForKeyboard(didKeyboardShow: false)
            })
            .disposed(by: disposeBag)
    }
    
    private func adjustViewForKeyboard(didKeyboardShow: Bool) {
        self.reasonTableView.snp.updateConstraints { make in
            if didKeyboardShow {
                make.top.equalTo(self.navigationView.snp.bottom)
            } else {
                make.top.equalTo(self.navigationView.snp.bottom).offset(70)
            }
        }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func setReasonTextViewUI() {
        self.reasonTextView.text = self.reasonTextVeiwPlaceholder
        self.reasonTextView.textColor = .gamGray3
    }
}

// MARK: - UI

extension SecessionViewController {
    
    private func setUI() {
        self.view.backgroundColor = .gamGray1
        self.setReasonTextViewUI()
    }
    
    private func setLayout() {
        self.view.addSubviews([navigationView, titleLabel, subTitleLabel, reasonTableView, reasonTextView, buttonInfoLabel, confirmButton])
        
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
            make.top.equalTo(self.navigationView.snp.bottom).offset(70)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.reasons.count * Int(reasonCellHeight))
        }
        
        self.reasonTextView.snp.makeConstraints { make in
            make.top.equalTo(self.reasonTableView.snp.bottom)
            make.left.equalToSuperview().inset(23)
            make.right.equalToSuperview().inset(17)
            make.height.equalTo(109)
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

