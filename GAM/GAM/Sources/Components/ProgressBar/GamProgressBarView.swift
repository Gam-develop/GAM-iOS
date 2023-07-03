//
//  GamProgressBarView.swift
//  GAM
//
//  Created by Jungbin on 2023/07/03.
//

import UIKit
import SnapKit

final class GamProgressBarView: UIView {
    
    enum Step {
        case first
        case second
        case third
    }
    
    // MARK: UIComponents
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let progressView1: UIView = {
        let view = UIView()
        view.backgroundColor = .gamGray1
        return view
    }()
    
    private let progressView2: UIView = {
        let view = UIView()
        view.backgroundColor = .gamGray1
        return view
    }()
    
    private let progressView3: UIView = {
        let view = UIView()
        view.backgroundColor = .gamGray1
        return view
    }()
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    func setProgress(step: Step) {
        switch step {
        case .first:
            self.progressView1.backgroundColor = .gamBlack
            self.progressView2.backgroundColor = .gamGray1
            self.progressView3.backgroundColor = .gamGray1
        case .second:
            self.progressView1.backgroundColor = .gamGray1
            self.progressView2.backgroundColor = .gamBlack
            self.progressView3.backgroundColor = .gamGray1
        case .third:
            self.progressView1.backgroundColor = .gamGray1
            self.progressView2.backgroundColor = .gamGray1
            self.progressView3.backgroundColor = .gamBlack
        }
        
        self.setLayout()
    }
    
    private func setLayout() {
        self.addSubview(stackView)
        self.stackView.addArrangedSubviews([progressView1, progressView2, progressView3])
        
        self.stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
