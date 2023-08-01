//
//  BaseViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/06/30.
//

import UIKit
import MessageUI

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: Properties
    
    lazy var activityIndicator: GamActivityIndicatorView = {
        let activityIndicator: GamActivityIndicatorView = GamActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = self.view.center
        
        return activityIndicator
    }()
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackgroundColor()
    }
}

// MARK: Methods

extension BaseViewController {
    func hideTabBar() {
        if let tabBarController = self.tabBarController as? GamTabBarController {
            tabBarController.hideTabBar()
        }
    }
    
    func showTabBar() {
        if let tabBarController = self.tabBarController as? GamTabBarController {
            tabBarController.showTabBar()
        }
    }
    
    /// 화면 터치 시 키보드 내리는 메서드
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    /// 모든 뷰의 기본 Background color 설정
    private func setBackgroundColor() {
        self.view.backgroundColor = .gamGray1
    }
    
    /// 서버 통신 시작 시 Activity Indicator를 시작하는 메서드
    func startActivityIndicator() {
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    /// 서버 통신이 끝나면 Activity Indicator를 종료하는 메서드
    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
    }
    
    /// BackButton에 pop Action을 간편하게 주는 메서드.
    /// - 필요 시 override하여 사용
    @objc
    func setBackButtonAction(_ button: UIButton) {
        button.setAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func openUserBlockReportActionSheet(username: String, userID: Int) {
        let actionSheet: UIAlertController = UIAlertController(
            title: nil,
            message: "\(username) 님",
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "차단하기",
                style: .default,
                handler: { _ in
                    debugPrint("user Blocked 구현해랏")
                    self.navigationController?.popViewController(animated: true)
                }
            )
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "신고하기",
                style: .destructive,
                handler: { _ in
                    debugPrint("user Reported 구현해랏")
                }
            )
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "취소",
                style: .cancel,
                handler: nil
            )
        )
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func openUserContactEmailActionSheet(email: String) {
        let actionSheet: UIAlertController = UIAlertController(
            title: nil,
            message: email,
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "복사하기",
                style: .default,
                handler: { _ in
                    UIPasteboard.general.string = email
                }
            )
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "이메일 보내기",
                style: .default,
                handler: { _ in
                    self.openMailAppToUserEmail(email: email)
                }
            )
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "취소",
                style: .cancel,
                handler: nil
            )
        )
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension BaseViewController: MFMailComposeViewControllerDelegate {
    func openMailAppToUserEmail(email: String) {
        if MFMailComposeViewController.canSendMail() {
            let compseVC = MFMailComposeViewController()
            compseVC.mailComposeDelegate = self
            
            compseVC.setToRecipients([email])
            compseVC.setMessageBody(
"""


——————————————————————————
GAM 앱에서 보냈습니다.
"""
                , isHTML: false)
            
            self.present(compseVC, animated: true, completion: nil)
            
        } else {
            self.makeAlert(title: Message.unabledMailApp.text)
        }
    }
    
    func sendContactMail() {
        if MFMailComposeViewController.canSendMail() {
            let compseVC = MFMailComposeViewController()
            compseVC.mailComposeDelegate = self
            
            compseVC.setToRecipients(["must4rdev@gmail.com"])
            compseVC.setSubject("[감] 문의해요 👋")
            compseVC.setMessageBody(
"""
안녕하세요.
서비스를 이용주셔서 감사해요.
개선했으면 하는 부분 혹은 추가되었으면 하는 기능은 적극 반영해볼게요.
문의에 대한 답변은 빠른 시일내에 전송해주신 메일로 회신드리겠습니다.
——————————————————————————





——————————————————————————
User: \(String(describing: UserInfo.shared.userID ?? -1))
App Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
Device: \(self.deviceModelName())
OS Version: \(UIDevice.current.systemVersion)
"""
                , isHTML: false)
            
            self.present(compseVC, animated: true, completion: nil)
            
        } else {
            self.makeAlert(title: Message.unabledMailApp.text)
        }
    }
    
    private func deviceModelName() -> String {
        
        /// 시뮬레이터 확인
        var modelName = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] ?? ""
        if modelName.isEmpty == false && modelName.count > 0 {
            return modelName
        }
        
        /// 실제 디바이스 확인
        let device = UIDevice.current
        let selName = "_\("deviceInfo")ForKey:"
        let selector = NSSelectorFromString(selName)
        
        if device.responds(to: selector) {
            modelName = String(describing: device.perform(selector, with: "marketing-name").takeRetainedValue())
        }
        return modelName
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            switch result {
            case .cancelled, .saved: return
            case .sent:
                self.makeAlert(title: Message.completedSendContactMail.text)
            case .failed:
                self.makeAlert(title: Message.failedSendContactMail.text)
            @unknown default:
                self.makeAlert(title: Message.networkError.text)
            }
        }
    }
}
