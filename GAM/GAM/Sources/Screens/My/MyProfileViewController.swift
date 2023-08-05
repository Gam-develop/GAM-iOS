//
//  MyProfileViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/08/02.
//

import UIKit
import SnapKit

final class MyProfileViewController: BaseViewController {
    
    private enum Text {
        static let infoTitle = "내소개"
        static let tagTitle = "활동 분야"
        static let emailTitle = "이메일"
        static let emailPlaceholder = "이메일 주소를 입력해주세요."
        static let edit = "편집하기"
    }
    
    private enum Number {
        static let cellHorizontalSpacing: CGFloat = 16 * 2
        static let cellHeight = 30
    }
    
    // MARK: UIComponents
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    
    private let infoTitleLabel: GamSingleLineLabel = GamSingleLineLabel(text: Text.infoTitle, font: .subhead4Bold)
    
    private let profileInfoView: ProfileInfoView = ProfileInfoView(isEditable: false)
    
    private let tagTitleLabel: GamSingleLineLabel = GamSingleLineLabel(text: Text.tagTitle, font: .subhead4Bold)
    
    private let tagCollectionView: TagCollectionView = TagCollectionView(frame: .zero, collectionViewLayout: .init())
    
    private let emailTitleLabel: GamSingleLineLabel = GamSingleLineLabel(text: Text.emailTitle, font: .subhead4Bold)
    
    private let emailTextField: GamTextField = {
        let textField: GamTextField = GamTextField(type: .email)
        textField.placeholder = Text.emailPlaceholder
        textField.isEnabled = false
        return textField
    }()
    
    private let editButton: GamFullButton = {
        let button: GamFullButton = GamFullButton(type: .system)
        button.setTitle(Text.edit, for: .normal)
        return button
    }()
    
    // MARK: Properties
    
    private var superViewController: MyViewController?
    private var profile: UserProfileEntity = .init(userID: 0, name: "", isScrap: false, info: "", infoDetail: "", tags: [], email: "")
    
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
        
        self.setLayout()
        self.setTagCollectionView()
    }
    
    // MARK: Methods
    
    private func setTagCollectionView() {
        self.tagCollectionView.delegate = self
        self.tagCollectionView.dataSource = self
        self.tagCollectionView.allowsSelection = false
        self.tagCollectionView.register(cell: UnselectableTagCollectionViewCell.self)
    }
    
    func setData(profile: UserProfileEntity) {
        self.profile = profile
        self.profileInfoView.setData(
            info: profile.info,
            detail: profile.infoDetail
        )
        self.tagCollectionView.reloadData()
        self.emailTextField.text = profile.email
        self.editButton.setAction { [weak self] in
            self?.navigationController?.pushViewController(EditProfileViewController(profile: profile), animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MyProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.profile.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnselectableTagCollectionViewCell.className, for: indexPath) as? UnselectableTagCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.setData(data: self.profile.tags[indexPath.row].name)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MyProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizingCell: UnselectableTagCollectionViewCell = UnselectableTagCollectionViewCell()
        sizingCell.setData(data: Tag.shared.tags[indexPath.row].name)
        sizingCell.contentLabel.sizeToFit()
        
        let cellWidth = sizingCell.contentLabel.frame.width + Number.cellHorizontalSpacing
        let cellHeight = Number.cellHeight
        return CGSize(width: cellWidth, height: CGFloat(cellHeight))
    }
}

// MARK: - UI

extension MyProfileViewController {
    private func setLayout() {
        self.view.addSubviews([scrollView])
        self.scrollView.addSubview(contentView)
        self.contentView.addSubviews([infoTitleLabel, profileInfoView, tagTitleLabel, tagCollectionView, emailTitleLabel, emailTextField, editButton])
        
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
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
            make.height.equalTo(30)
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
        }
        
        self.editButton.snp.makeConstraints { make in
            make.top.equalTo(self.emailTextField.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(40)
        }
    }
}
