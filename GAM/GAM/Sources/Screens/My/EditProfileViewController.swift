//
//  EditProfileViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/08/05.
//

import UIKit
import SnapKit

final class EditProfileViewController: BaseViewController {
    
    // MARK: UIComponents
    
    // MARK: Properties
    
    private var profile: UserProfileEntity = .init(userID: 0, name: "", isScrap: false, info: "", infoDetail: "", tags: [], email: "")
    
    // MARK: Initializer
    
    init(profile: UserProfileEntity) {
        super.init(nibName: nil, bundle: nil)
        
        self.profile = profile
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
    }
    
    // MARK: Methods
}

// MARK: - UI

extension EditProfileViewController {
    private func setLayout() {
        self.view.addSubviews([])
    }
}
