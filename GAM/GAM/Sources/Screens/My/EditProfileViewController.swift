//
//  EditProfileViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/08/05.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class EditProfileViewController: BaseViewController {
    
    private enum Text {
        static let title = "프로필"
        static let infoTitle = "내소개"
        static let tagTitle = "활동 분야"
        static let emailTitle = "이메일"
        static let emailPlaceholder = "이메일 주소를 입력해 주세요."
        static let profileInfo = "한 줄 소개를 입력해 주세요."
        static let tagInfo = "최소 1개 선택해 주세요."
        static let emailInfo = "올바른 이메일을 입력해 주세요."
    }
    
    private enum Number {
        static let cellHorizontalSpacing: CGFloat = 16 * 2
        static let cellHeight = 30
    }
    
    // MARK: UIComponents
    
    private let navigationView: GamNavigationView = {
        let view: GamNavigationView = GamNavigationView(type: .backTitleSave)
        view.setCenterTitle(Text.title)
        return view
    }()
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    
    private let infoTitleLabel: GamSingleLineLabel = GamSingleLineLabel(text: Text.infoTitle, font: .subhead4Bold)
    
    private let profileInfoView: ProfileInfoView = ProfileInfoView(isEditable: true)
    
    private let profileInfoLabel: GamSingleLineLabel = GamSingleLineLabel(text: Text.profileInfo, font: .caption1Regular, color: .gamRed)
    
    private let profileInfoDetailCountLabel: GamSingleLineLabel = {
        let label: GamSingleLineLabel = GamSingleLineLabel(text: "0/150", font: .caption1Regular, color: .gamGray3)
        label.textAlignment = .right
        return label
    }()
    
    private let tagTitleLabel: GamSingleLineLabel = GamSingleLineLabel(text: Text.tagTitle, font: .subhead4Bold)
    
    private let tagCollectionView: TagCollectionView = TagCollectionView(frame: .zero, collectionViewLayout: .init())
    
    private let tagInfoLabel: GamSingleLineLabel = {
        let label: GamSingleLineLabel = GamSingleLineLabel(text: Text.tagInfo, font: .caption1Regular, color: .gamRed)
        label.textAlignment = .right
        return label
    }()
    
    private let emailTitleLabel: GamSingleLineLabel = GamSingleLineLabel(text: Text.emailTitle, font: .subhead4Bold)
    
    private let emailTextField: GamTextField = {
        let textField: GamTextField = GamTextField(type: .email)
        textField.setGamPlaceholder(Text.emailPlaceholder)
        return textField
    }()
    
    private let emailInfoLabel: GamSingleLineLabel = GamSingleLineLabel(text: Text.emailInfo, font: .caption1Regular, color: .gamRed)
    
    // MARK: Properties
    
    private var keyboardHeight: CGFloat = 0
    private var profile: UserProfileEntity = .init(userID: 0, name: "", isScrap: false, info: "", infoDetail: "", tags: [], email: "")
    private let disposeBag: DisposeBag = DisposeBag()
    private var profileInfoObservation: NSKeyValueObservation?
    private var tagObservation: NSKeyValueObservation?
    private var emailObservation: NSKeyValueObservation?
    private var isSaveButtonEnable: [Bool] = [false, false, false] {
        didSet {
            self.navigationView.saveButton.isEnabled = self.isSaveButtonEnable[0]
                && self.isSaveButtonEnable[1]
                && self.isSaveButtonEnable[2]
        }
    }
    
    // MARK: Initializer
    
    init(profile: UserProfileEntity) {
        super.init(nibName: nil, bundle: nil)
        
        self.profile = profile
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.profileInfoObservation?.invalidate()
        self.tagObservation?.invalidate()
        self.emailObservation?.invalidate()
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.setTagCollectionView()
        self.setBackButtonAction(self.navigationView.backButton)
        self.setEmailTextField()
        self.setSaveButtonAction()
        self.checkSaveButtonEnable()
        self.setData(profile: self.profile)
        self.setProfileInfoView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardObserver(willShow: #selector(self.keyboardWillShow(_:)), willHide: #selector(self.keyboardWillHide(_:)))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.removeKeyboardObserver()
    }
    
    // MARK: Methods
    
    private func setTagCollectionView() {
        self.tagCollectionView.delegate = self
        self.tagCollectionView.dataSource = self
        self.tagCollectionView.allowsSelection = true
        self.tagCollectionView.register(cell: TagCollectionViewCell.self)
    }
    
    func setData(profile: UserProfileEntity) {
        self.profile = profile
        self.profileInfoView.setData(
            info: profile.info,
            detail: profile.infoDetail
        )
        self.tagCollectionView.reloadData()
        
        _ = profile.tags.map { tag in
            self.tagCollectionView.selectItem(at: IndexPath(row: tag.id, section: 0), animated: true, scrollPosition: .init())
            self.collectionView(self.tagCollectionView, didSelectItemAt: IndexPath(row: tag.id, section: 0))
        }
        
        self.emailTextField.text = profile.email
        self.profileInfoDetailCountLabel.text = "\(profile.infoDetail.count)/150"
        
        self.profileInfoLabel.isHidden = profile.info.count != 0
        self.tagInfoLabel.isHidden = profile.tags.count > 0
        self.emailInfoLabel.isHidden = true
    }
    
    @objc
    func keyboardWillShow(_ notification: NSNotification) {
        if emailTextField.isEditing {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                self.keyboardHeight = keyboardRectangle.height
                self.scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentOffset.y + self.keyboardHeight - 40.adjustedH), animated: true)
            }
        }
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        if emailTextField.isEditing {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                self.keyboardHeight = keyboardRectangle.height
                self.scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height), animated: true)
            }
        }
    }
    
    private func setProfileInfoView() {
        self.profileInfoView.infoTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { (owner, changedText) in
                self.profileInfoView.infoTextField.text?.removeLastSpace()
                if changedText.count > 20 {
                    self.profileInfoView.infoTextField.deleteBackward()
                }
                if changedText.count > 0 {
                    let regex = "[가-힣ㄱ-ㅎㅏ-ㅣA-Za-z0-9\\s]{1,20}"
                    if NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: changedText) && changedText.trimmingCharacters(in: .whitespaces).count >= 1 {
                        self.profileInfoView.layer.borderWidth = 0
                        self.profileInfoLabel.isHidden = true
                    } else {
                        self.profileInfoView.layer.borderWidth = 1
                        self.profileInfoLabel.isHidden = false
                    }
                } else {
                    self.profileInfoView.layer.borderWidth = 1
                    self.profileInfoLabel.isHidden = false
                }
            })
            .disposed(by: self.disposeBag)
        
        self.profileInfoView.detailTextView.rx.text
            .orEmpty
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (owner, changedText) in
                self.profileInfoView.detailTextView.text.removeLastSpace()
                if changedText.count > 150 {
                    self.profileInfoView.detailTextView.deleteBackward()
                } else {
                    self.profileInfoDetailCountLabel.text = "\(changedText.count)/150"
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setEmailTextField() {
        self.emailTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (owner, changedText) in
                if changedText.count > 0 {
                    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                    if NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: changedText) && changedText.trimmingCharacters(in: .whitespaces).count >= 1 {
                        owner.emailInfoLabel.isHidden = true
                    } else {
                        owner.emailInfoLabel.isHidden = false
                    }
                } else {
                    owner.emailInfoLabel.isHidden = true
                }
            })
            .disposed(by: self.disposeBag)
        
        self.emailTextField.clearButton.rx.tap
            .withUnretained(self)
            .bind { (owner, _) in
                owner.emailInfoLabel.isHidden = true
            }
            .disposed(by: disposeBag)
    }
    
    private func setSaveButtonAction() {
        self.navigationView.saveButton.setAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func checkSaveButtonEnable() {
        self.profileInfoObservation = self.profileInfoLabel.observe(\.isHidden, options: [.old, .new]) { label, change in
            if let isHidden = change.newValue, isHidden != change.oldValue {
                self.isSaveButtonEnable[0] = isHidden
            } else {
                self.isSaveButtonEnable[0] = change.oldValue ?? true
            }
        }
        
        self.tagObservation = self.tagInfoLabel.observe(\.isHidden, options: [.old, .new]) { label, change in
            if let isHidden = change.newValue, isHidden != change.oldValue {
                self.isSaveButtonEnable[1] = isHidden
            } else {
                self.isSaveButtonEnable[1] = change.oldValue ?? true
            }
        }
        
        self.emailObservation = self.emailInfoLabel.observe(\.isHidden, options: [.old, .new]) { label, change in
            if let isHidden = change.newValue, isHidden != change.oldValue {
                self.isSaveButtonEnable[2] = isHidden
            } else {
                self.isSaveButtonEnable[2] = change.oldValue ?? true
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension EditProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Tag.shared.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.className, for: indexPath) as? TagCollectionViewCell
        else { return UICollectionViewCell() }
        cell.setData(data: Tag.shared.tags[indexPath.row].name)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension EditProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizingCell: TagCollectionViewCell = TagCollectionViewCell()
        sizingCell.setData(data: Tag.shared.tags[indexPath.row].name)
        sizingCell.contentLabel.sizeToFit()
        
        let cellWidth = sizingCell.contentLabel.frame.width + Number.cellHorizontalSpacing
        let cellHeight = Number.cellHeight
        return CGSize(width: cellWidth, height: CGFloat(cellHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.tagCollectionView.indexPathsForSelectedItems?.count ?? 0 > 3 {
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as? TagCollectionViewCell {
                cell.isSelected = true
            }
        }
        self.tagInfoLabel.isHidden = self.tagCollectionView.indexPathsForSelectedItems?.count != 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TagCollectionViewCell {
            cell.isSelected = false
        }
        self.tagInfoLabel.isHidden = self.tagCollectionView.indexPathsForSelectedItems?.count != 0
    }
}

// MARK: - UI

extension EditProfileViewController {
    private func setLayout() {
        self.view.addSubviews([navigationView, scrollView])
        self.scrollView.addSubview(contentView)
        self.contentView.addSubviews([infoTitleLabel, profileInfoView, tagTitleLabel, tagCollectionView, emailTitleLabel, emailTextField, profileInfoLabel, tagInfoLabel, emailInfoLabel, profileInfoDetailCountLabel])
        
        self.navigationView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        self.contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        
        self.infoTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(26)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(27)
        }
        
        self.profileInfoView.snp.makeConstraints { make in
            make.top.equalTo(self.infoTitleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(194)
        }
        
        self.tagTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.profileInfoView.snp.bottom).offset(44)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(27)
        }
        
        self.tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.tagTitleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(156)
        }
        
        self.emailTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.tagCollectionView.snp.bottom).offset(44)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(27)
        }
        
        self.emailTextField.snp.makeConstraints { make in
            make.top.equalTo(self.emailTitleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(56)
        }
        
        self.profileInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.profileInfoView.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        self.tagInfoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.tagCollectionView.snp.top).offset(-10)
            make.right.equalToSuperview().inset(24)
        }
        
        self.emailInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.emailTextField.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        self.profileInfoDetailCountLabel.snp.makeConstraints { make in
            make.top.equalTo(self.profileInfoLabel)
            make.right.equalToSuperview().inset(24)
        }
    }
}
