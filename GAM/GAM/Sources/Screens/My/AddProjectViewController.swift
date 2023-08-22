//
//  AddProjectViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/08/06.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class AddProjectViewController: BaseViewController {
    
    private enum Text {
        static let title = "프로젝트"
        static let image = "대표 이미지"
        static let imageDetail = "이미지 크기 및 사이즈에 대한 규격 설명입니다."
        static let projectTitle = "제목"
        static let projectPlaceholder = "프로젝트 제목을 작성해 주세요."
        static let projectDetail = "설명"
        static let projectDetailPlaceholder = "프로젝트에 대하여 간단히 설명해 주세요!"
    }
    
    private enum Number {
        static let projectTitleLimit = 12
        static let projectDetailLimit = 150
    }
    
    // MARK: UIComponents
    
    private let navigationView: GamNavigationView = {
        let view: GamNavigationView = GamNavigationView(type: .backTitleSave)
        view.setCenterTitle(Text.title)
        view.saveButton.isEnabled = false
        return view
    }()
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    
    private let imageTitleLabel: GamStarLabel = GamStarLabel(text: Text.image, font: .subhead4Bold)
    private let imageDetailLabel: GamSingleLineLabel = GamSingleLineLabel(text: Text.imageDetail, font: .caption1Regular, color: .gamGray3)
    private let projectImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.backgroundColor = .gamWhite
        imageView.makeRounded(cornerRadius: 10)
        return imageView
    }()
    private let projectImageUploadButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setImage(.icnUploadImage, for: .normal)
        return button
    }()
    
    private let projectTitleLabel: GamStarLabel = GamStarLabel(text: Text.projectTitle, font: .subhead4Bold)
    private let projectTitleTextField: GamTextField = {
        let textField: GamTextField = GamTextField(type: .projectTitle)
        textField.placeholder = Text.projectPlaceholder
        return textField
    }()
    private let projectTitleInfoLabel: GamSingleLineLabel = GamSingleLineLabel(text: Text.projectPlaceholder, font: .caption1Regular, color: .gamRed)
    private let projectTitleCountLabel: GamSingleLineLabel = {
        let label: GamSingleLineLabel = GamSingleLineLabel(text: "\(0)/\(Number.projectTitleLimit)", font: .caption1Regular, color: .gamGray3)
        label.textAlignment = .right
        return label
    }()
    
    private let projectDetailLabel: GamSingleLineLabel = GamSingleLineLabel(text: Text.projectDetail, font: .subhead4Bold)
    private let projectDetailTextView: UITextView = {
        let textView: UITextView = UITextView()
        textView.makeRounded(cornerRadius: 8)
        textView.font = .caption3Medium
        textView.textColor = .gamBlack
        textView.contentInset = .zero
        textView.textContainerInset = .init(top: 12, left: 16, bottom: 12, right: 16)
        textView.textContainer.lineFragmentPadding = .zero
        return textView
    }()
    private let projectDetailCountLabel: GamSingleLineLabel = {
        let label: GamSingleLineLabel = GamSingleLineLabel(text: "\(0)/\(Number.projectDetailLimit)", font: .caption1Regular, color: .gamGray3)
        label.textAlignment = .right
        return label
    }()
    
    // MARK: Properties
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.dismissKeyboard()
        self.setBackButtonAction(self.navigationView.backButton)
        self.setProjectTitleInfoLabel()
        self.setProjectTitleClearButtonAction()
        self.setProjectDetailTextInfoLabel()
    }
    
    // MARK: Methods
    
    private func setProjectTitleInfoLabel() {
        self.projectTitleTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { (owner, changedText) in
                owner.projectTitleInfoLabel.isHidden = changedText.count > 0
                self.projectTitleCountLabel.text = "\(changedText.count)/\(Number.projectTitleLimit)"
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setProjectTitleClearButtonAction() {
        self.projectTitleTextField.clearButton.setAction { [weak self] in
            self?.projectTitleCountLabel.text = "\(0)/\(Number.projectTitleLimit)"
            self?.projectTitleInfoLabel.isHidden = false
            self?.projectTitleTextField.layer.borderWidth = 1
        }
    }
    
    private func setProjectDetailTextInfoLabel() {
        self.projectDetailTextView.rx.text
            .orEmpty
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { (owner, changedText) in
                owner.projectDetailTextView.text?.removeLastSpace()
                if changedText.count > Number.projectDetailLimit {
                    owner.projectDetailTextView.deleteBackward()
                }
                self.projectDetailCountLabel.text = "\(changedText.count)/\(Number.projectDetailLimit)"
            })
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension AddProjectViewController {
    private func setLayout() {
        self.view.addSubviews([navigationView, scrollView])
        self.scrollView.addSubview(contentView)
        
        self.contentView.addSubviews([
            imageTitleLabel, imageDetailLabel, projectImageView, projectImageUploadButton,
            projectTitleLabel, projectTitleTextField, projectTitleInfoLabel, projectTitleCountLabel,
            projectDetailLabel, projectDetailTextView, projectDetailCountLabel
        ])
        
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
        
        self.imageTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(27)
        }
        
        self.imageDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(self.imageTitleLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(18)
        }
        
        self.projectImageView.snp.makeConstraints { make in
            make.top.equalTo(self.imageDetailLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(self.projectImageView.snp.width)
        }
        
        self.projectImageUploadButton.snp.makeConstraints { make in
            make.center.equalTo(self.projectImageView)
            make.width.height.equalTo(48)
        }
        
        self.projectTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.projectImageView.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(27)
        }
        
        self.projectTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(self.projectTitleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        
        self.projectTitleInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.projectTitleTextField.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(18)
        }
        
        self.projectTitleCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.projectTitleInfoLabel)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(18)
        }
        
        self.projectDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(self.projectTitleCountLabel.snp.bottom).offset(28)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(27)
        }
        
        self.projectDetailTextView.snp.makeConstraints { make in
            make.top.equalTo(self.projectDetailLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(141)
        }
        
        self.projectDetailCountLabel.snp.makeConstraints { make in
            make.top.equalTo(self.projectDetailTextView.snp.bottom).offset(8)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(18)
            make.bottom.equalToSuperview().inset(30)
        }
    }
}
