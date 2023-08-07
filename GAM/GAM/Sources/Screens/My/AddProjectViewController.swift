//
//  AddProjectViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/08/06.
//

import UIKit
import SnapKit

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
    
    // MARK: Properties
    
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
    }
    
    // MARK: Methods
    
    
}

// MARK: - UI

extension AddProjectViewController {
    private func setLayout() {
        self.view.addSubviews([navigationView, scrollView])
        self.scrollView.addSubview(contentView)
        
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
            make.height.equalTo(200)
        }
    }
}
