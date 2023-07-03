//
//  GamActivityIndicatorView.swift
//  GAM
//
//  Created by Jungbin on 2023/07/03.
//

import UIKit

final class GamActivityIndicatorView: UIActivityIndicatorView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        self.color = .gamYellow
        self.hidesWhenStopped = true
        self.style = .medium
        self.stopAnimating()
    }
}
