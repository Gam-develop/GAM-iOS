//
//  GamTabBarController.swift
//  GAM
//
//  Created by Jungbin on 2023/06/30.
//

import UIKit

final class GamTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    enum Text {
        static let homeTitle = "홈"
        static let homeIconName = "homeTabIcon"
        static let magazineTitle = "매거진"
        static let magazineIconName = "magazineTabIcon"
        static let browseTitle = "둘러보기"
        static let browseIconName = "browseTabIcon"
        static let mypageTitle = "마이"
        static let mypageIconName = "mypageTabIcon"
        static let selected = "Selected"
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTabBarItemStyle()
        self.setTabBarItems()
        self.setUI()
    }
    
    // MARK: Methods
    
    private func makeTabVC(vc: UIViewController, tabBarTitle: String, tabBarImg: String, tabBarSelectedImg: String) -> UIViewController {
        
        vc.tabBarItem = UITabBarItem(
            title: tabBarTitle,
            image: UIImage(named: tabBarImg)?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: tabBarSelectedImg)?.withRenderingMode(.alwaysOriginal)
        )
        vc.tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
        return vc
    }
    
    private func setTabBarItems() {
        self.delegate = self
        
        let homeTab: UIViewController = self.makeTabVC(
            vc: BaseNavigationController(rootViewController: HomeViewController()),
            tabBarTitle: Text.homeTitle,
            tabBarImg: Text.homeIconName,
            tabBarSelectedImg: Text.homeIconName + Text.selected
        )
        homeTab.tabBarItem.tag = 0
        
        let magazineTab: UIViewController  = self.makeTabVC(
            vc: BaseNavigationController(rootViewController: MagazineViewController()),
            tabBarTitle: Text.magazineTitle,
            tabBarImg: Text.magazineIconName,
            tabBarSelectedImg: Text.magazineIconName + Text.selected
        )
        magazineTab.tabBarItem.tag = 1
        
        let browseTab: UIViewController  = self.makeTabVC(
            vc: BaseNavigationController(rootViewController: BrowseViewController()),
            tabBarTitle: Text.browseTitle,
            tabBarImg: Text.browseIconName,
            tabBarSelectedImg: Text.browseIconName + Text.selected
        )
        browseTab.tabBarItem.tag = 2
        
        let mypageTab: UIViewController = self.makeTabVC(
            vc: BaseNavigationController(rootViewController: MypageViewController()),
            tabBarTitle: Text.mypageTitle,
            tabBarImg: Text.mypageIconName,
            tabBarSelectedImg: Text.mypageIconName + Text.selected
        )
        mypageTab.tabBarItem.tag = 3
        
        let tabs = [homeTab, magazineTab, browseTab, mypageTab]
        self.setViewControllers(tabs, animated: true)
    }
    
    private func setTabBarItemStyle() {
        self.tabBar.tintColor = .gamBlack
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)], for: .normal)
        self.tabBar.layer.cornerRadius = tabBar.frame.height * 0.35
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setUI() {
        self.tabBar.standardAppearance.backgroundColor = .white
        UITabBar.clearShadow()
        self.tabBar.layer.applyShadow(color: UIColor.lightGray, alpha: 0.2, x: 0, y: -9, blur: 18)
        self.modalPresentationStyle = .fullScreen
    }
    
    func hideTabBar() {
        self.tabBar.isHidden = true
    }
    
    func showTabBar() {
        self.tabBar.isHidden = false
    }
}
