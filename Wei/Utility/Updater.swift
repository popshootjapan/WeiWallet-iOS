//
//  Updater.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/25.
//  Copyright © 2018 popshoot All rights reserved.
//

import RxSwift
import RxCocoa

protocol UpdaterProtocol {
    var refreshBalance: PublishSubject<Void> { get }
    var refreshTransactions: PublishSubject<Void> { get }
    var refreshRate: PublishSubject<Void> { get }
}

final class Updater: UpdaterProtocol {
    let refreshBalance = PublishSubject<Void>()
    let refreshTransactions = PublishSubject<Void>()
    let refreshRate = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        let blockInterval = 15.0
        let ticker = Driver<Int>
            .interval(blockInterval)
            .map { _ in }
        
        ticker
            .drive(refreshBalance)
            .disposed(by: disposeBag)
        
        ticker
            .drive(refreshTransactions)
            .disposed(by: disposeBag)
        
        ticker
            .drive(refreshRate)
            .disposed(by: disposeBag)
    }
}
