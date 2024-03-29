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
    private let reasonTextVeiwPlaceholder = "다른 이유가 있으시면 말씀해주세요."
    
    // MARK: UI Component
    
    private let navigationView: GamNavigationView = {
        let view = GamNavigationView(type: .backTitle)
        view.setCenterTitle("탈퇴하기")
        return view
    }()
    
    // TODO: - 닉네임 넣어야됨
    private let titleLabel = GamSingleLineLabel(text: "좋은 영감을 주셔서 감사했어요",
                                                font: .headline1SemiBold,
                                                color: .black)
    
    private let subTitleLabel = GamSingleLineLabel(text: "감을 떠나시는 이유가 궁금해요.",
                                               font: .body1Regular,
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
        let reasonsObservable: Observable<[String]> = Observable.of(self.viewModel.reasons)
        
        reasonsObservable
            .bind(to: self.reasonTableView.rx.items(cellIdentifier: SecessionTableViewCell.className, cellType: SecessionTableViewCell.self)) { (index: Int, element: String, cell: SecessionTableViewCell) in
                cell.setReasonLabel(element)
                
                cell.checkboxTap
                    .asDriver()
                    .drive(with: self, onNext: { owner, _ in
                        let isSelected = cell.setSelectedState()
                        
                        if index == owner.viewModel.reasons.index(before: owner.viewModel.reasons.endIndex) {
                            owner.reasonTextView.isHidden = !isSelected
                        }
                        
                        owner.viewModel.checkConfirmButtonState(index: index, isSelected: isSelected)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        Observable.just(reasonCellHeight)
            .bind(to: self.reasonTableView.rx.rowHeight)
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        self.viewModel.state.confirmButtonState
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
                if owner.reasonTextView.textColor != .gamGray3 {
                    owner.viewModel.state.reasonText.accept(text)
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
        
        self.confirmButton.rx.tap
            .bind(to: self.viewModel.action.deleteAccount)
            .disposed(by: self.disposeBag)
        
        self.viewModel.action.popViewController
            .asDriver(onErrorJustReturn: ())
            .drive(with: self, onNext: { owner, _ in
                owner.navigationController?.popToRootViewController(animated: true)
                let signInViewController: BaseViewController = SignInViewController()
                signInViewController.modalTransitionStyle = .crossDissolve
                signInViewController.modalPresentationStyle = .fullScreen
                owner.present(signInViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.action.showNetworkErrorAlert
            .asDriver(onErrorJustReturn: ())
            .drive(with: self, onNext: { owner, _ in
                owner.showNetworkErrorAlert()
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
        self.reasonTextView.setTextWithStyle(to: self.reasonTextVeiwPlaceholder, style: .caption2Regular, color: .gamGray3)
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
            make.top.equalTo(self.navigationView.snp.bottom).offset(40)
            make.left.equalToSuperview().inset(23)
        }
        
        self.subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(6)
            make.left.equalToSuperview().inset(23)
        }
        
        self.reasonTableView.snp.makeConstraints { make in
            make.top.equalTo(self.subTitleLabel.snp.bottom).offset(25)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.viewModel.reasons.count * Int(reasonCellHeight))
        }
        
        self.reasonTextView.snp.makeConstraints { make in
            make.top.equalTo(self.reasonTableView.snp.bottom)
            make.left.equalToSuperview().inset(23)
            make.right.equalToSuperview().inset(17)
            make.height.equalTo(109)
        }
        
        self.buttonInfoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.confirmButton.snp.top).offset(-15)
        }
        
        self.confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
    }
}

