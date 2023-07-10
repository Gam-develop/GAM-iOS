//
//  MagazineDetailViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/09.
//

import UIKit
import WebKit
import SnapKit

final class MagazineDetailViewController: BaseViewController {
    
    enum Text {
        static let title = "매거진"
    }
    
    // MARK: UIComponents
    
    private let navigationView: GamNavigationView = {
        let view: GamNavigationView = GamNavigationView(type: .backTitleShare)
        view.setCenterTitle(Text.title)
        return view
    }()
    
    private let webView: WKWebView = WKWebView()
    
    // MARK: Properties
    
    private var url: String = ""
    
    // MARK: Initializer
    
    init(url: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackButtonAction(self.navigationView.backButton)
        self.setLayout()
        self.setWebView()
        self.setShareButtonAction()
    }
    
    // MARK: Methods
    
    private func setWebView() {
        self.webView.navigationDelegate = self
        guard let url = URL(string: self.url) else { return }
        
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
    
    private func setShareButtonAction() {
        self.navigationView.shareButton.setAction { [weak self] in
            guard let self = self else { return }
            let objectsToShare: [String] = [self.url]
            
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}

// MARK: - WKNavigationDelegate

extension MagazineDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.startActivityIndicator()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.stopActivityIndicator()
    }
}

// MARK: - UI

extension MagazineDetailViewController {
    private func setLayout() {
        self.view.addSubviews([navigationView, webView])
        
        self.navigationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.webView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
