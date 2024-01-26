//
//  SecessionViewModel.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/23/24.
//

import Foundation
import RxSwift
import RxRelay

final class SecessionViewModel {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    let reasons = [
        "매거진 컨텐츠가 유익하지 않아요.",
        "매거진 발행 주기가 늦어요.",
        "포트폴리오에서 영감을 얻지 못했어요.",
        "앱 오류가 자주 발생해요.",
        "직접 입력할게요."
    ]
    
    private var selectedItems: [Int] = []
    let confirmButtonState: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let reasonText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    init() {
        self.setBinding()
    }
}

// MARK: - Methods

extension SecessionViewModel {
    
    func setBinding() {
        self.reasonText
            .map { $0.isEmpty }
            .distinctUntilChanged()
            .subscribe(with: self, onNext: { owner, isEmpty in
                owner.confirmButtonState.accept(!isEmpty)
            })
            .disposed(by: self.disposeBag)
    }
    
    func checkConfirmButtonState(index: Int, isSelected: Bool) {
        if isSelected {
            self.selectedItems.append(index)
        } else {
            self.selectedItems.removeAll { $0 == index }
        }
        
        if selectedItems.isEmpty {
            self.confirmButtonState.accept(false)
        } else {
            let isLastItemSelected = selectedItems.contains(reasons.count - 1)
            self.confirmButtonState.accept(isLastItemSelected ? !self.reasonText.value.isEmpty : true)
        }

    }
    
    func deleteAccount() {
        // TODO: 서버 나오면 api 연결
    }
}
