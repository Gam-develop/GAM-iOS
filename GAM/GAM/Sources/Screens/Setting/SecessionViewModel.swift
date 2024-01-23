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
    
    let selectedItems: BehaviorRelay<[Int]> = BehaviorRelay(value: [])
}

// MARK: - Network

extension SecessionViewModel {
    
    func deleteAccount() {
        // TODO: 서버 나오면 api 연결
    }
}
