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
    
    private var selectedItems: [Int] = []
    let confirmButtonState: BehaviorRelay<Bool> = BehaviorRelay(value: false)
}

// MARK: - Network

extension SecessionViewModel {
    
    func checkConfirmButtonState(index: Int, isSelected: Bool) {
        if isSelected {
            self.selectedItems.append(index)
        } else {
            self.selectedItems.removeAll { $0 == index }
        }
        
        // 만약 직접 입력 선택을 누른 상태라면 일단 false 반환
        if selectedItems.contains(4) {
            self.confirmButtonState.accept(false)
        } else {
            self.confirmButtonState.accept(!selectedItems.isEmpty)
        }
    }
    
    func deleteAccount() {
        // TODO: 서버 나오면 api 연결
    }
}
