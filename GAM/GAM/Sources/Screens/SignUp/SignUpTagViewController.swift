//
//  SignUpTagViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/07.
//

import UIKit
import SnapKit

final class SignUpTagViewController: BaseViewController {
    
    enum Text {
        static let question = "님,\n\n어떤 분야에서\n활동 중인감?"
    }
    
    // MARK: UIComponents
    
    private let progressBarView: GamProgressBarView = GamProgressBarView()
    private let navigationView: GamNavigationView = GamNavigationView(type: .back)
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.font = .headline4Bold
        label.textColor = .gamBlack
        label.textAlignment = .left
        return label
    }()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.progressBarView.setProgress(step: .second)
        self.setUsername()
        self.setBackButtonAction(self.navigationView.backButton)
    }
    
    // MARK: Methods
    
    private func setUsername() {
        self.questionLabel.text = "\(SignUpInfo.shared.username ?? "")님,\n\n어떤 분야에서\n활동 중인감?"
        self.questionLabel.sizeToFit()
    }
}

// MARK: - UI

extension SignUpTagViewController {
    private func setLayout() {
        self.view.addSubviews([progressBarView, navigationView, questionLabel])
        
        self.progressBarView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(14)
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
        
        self.navigationView.snp.makeConstraints { make in
            make.top.equalTo(self.progressBarView.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview()
        }
        
        self.questionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.progressBarView.snp.bottom).offset(75)
            make.left.right.equalToSuperview().inset(20)
        }
    }
}

