//
//  MagazineViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/01.
//

import UIKit
import SnapKit
import RxSwift

final class MagazineViewController: BaseViewController {
    
    private enum Metric {
        static let headerHeight = 56.0
        static let headerViewHorizontalInset = 12.0
        static let horizontalInset = 20.0
        static let pageHeight = UIScreen.main.bounds.width * 1.3
    }
    
    // MARK: UIComponents
    
    private let tabHeaderView = PagingTabHeaderView()
    private let scrollView = UIScrollView()
    private let stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    // MARK: Properties
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var items = ["발견", "스크랩"]
        .enumerated()
        .map { index, str in HeaderItemType(title: str, isSelected: index == 0) }
    private var lastSelectedIndex: Int {
        items.firstIndex(where: { $0.isSelected }) ?? 0
    }
    fileprivate var contentViewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers()
        setUpViews()
        self.setLayout()
        self.bindTabHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabHeaderView.collectionView.reloadData()
        self.bindTabHeader()
        
        DispatchQueue.main.async {
            self.tabHeaderView.rx.updateUnderline.onNext(self.lastSelectedIndex)
        }
    }
    
    private func setViewControllers() {
        items
            .map(\.title)
            .forEach { title in
                let vc = LabelViewController()
                vc.titleText = title
                contentViewControllers.append(vc)
            }
    }
    
    private func setUpViews() {
//        pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        self.addChild(pageViewController)
        self.pageViewController.didMove(toParent: self)
        self.pageViewController.setViewControllers([contentViewControllers[0]], direction: .forward, animated: false)
    }
}

// MARK: - UI

extension MagazineViewController {
    private func setLayout() {
        self.view.addSubviews([tabHeaderView, scrollView])
        self.scrollView.addSubview(stackView)
        self.stackView.addArrangedSubview(pageViewController.view)
        
        self.tabHeaderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview().inset(Metric.headerViewHorizontalInset)
            $0.height.equalTo(Metric.headerHeight)
        }
        
        self.scrollView.snp.makeConstraints {
            $0.top.equalTo(tabHeaderView.snp.bottom)
            $0.left.right.equalToSuperview().inset(Metric.horizontalInset)
            $0.bottom.equalToSuperview()
        }
        
        self.stackView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        // height 지정 필수
        self.pageViewController.view.snp.makeConstraints {
            $0.height.equalTo(Metric.pageHeight)
        }
    }
    
    private func bindTabHeader() {
        
        Observable
            .just(items)
            .bind(to: tabHeaderView.rx.setItems)
            .disposed(by: disposeBag)
        
        tabHeaderView.rx.onIndexSelected
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { ss, newSelectedIndex in
                ss.updatePageView(newSelectedIndex)
                ss.updateTapHeaderCell(newSelectedIndex)
            }
            .disposed(by: disposeBag)
    }
    
    private func updateTapHeaderCell(_ index: Int) {
        debugPrint(#function)
//        debugPrint(index, self.lastSelectedIndex)
//        let lastSelectedIndex = lastSelectedIndex
        guard index != lastSelectedIndex else {
            debugPrint("last")
            return
            
        }
        debugPrint(#function)
        items[lastSelectedIndex].isSelected = false
        items[index].isSelected = true
        
        let updateHeaderItemTypes = [
            UpdateHeaderItemType(lastSelectedIndex, items[lastSelectedIndex]),
            UpdateHeaderItemType(index, items[index])
        ]
        
        tabHeaderView.rx.updateUnderline.onNext(index)
        
        Observable
            .just(updateHeaderItemTypes)
            .take(1)
            .filter { !$0.isEmpty }
            .bind(to: tabHeaderView.rx.updateCells)
            .disposed(by: disposeBag)
    }
    
    private func updatePageView(_ index: Int) {
        let viewController = contentViewControllers[index]
        let direction = lastSelectedIndex < index ? UIPageViewController.NavigationDirection.forward : .reverse
        self.pageViewController.setViewControllers([viewController], direction: direction, animated: true)
    }
}

extension MagazineViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed else { return }
        updateTabIndex()
    }
    
    private func updateTabIndex() {
        guard
            let vc = (pageViewController.viewControllers?.first as? LabelViewController),
            let id = vc.id,
            let currentIndex = items.firstIndex(where: { id == $0.title })
        else { return }
        
        updateTapHeaderCell(currentIndex)
    }
}

var randomColor: UIColor {
    UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
}
