//
//  BalanceStore.swift
//  Wei
//
//  Created by omatty198 on 2018/04/26.
//  Copyright © 2018年 yz. All rights reserved.
//

import Foundation
import EthereumKit
import RxSwift
import RxCocoa

protocol BalanceStoreProtocol {
    var etherBalance: Observable<Balance> { get }
    var fiatBalance: Observable<String> { get }
}

final class BalanceStore: Injectable, BalanceStoreProtocol {
    
    typealias Dependency = (
        GethRepositoryProtocol,
        WalletManagerProtocol,
        UpdaterProtocol,
        RateStoreProtocol
    )
    
    let etherBalance: Observable<Balance>
    let fiatBalance: Observable<String>
    
    init(dependency: Dependency) {
        let (geth, wallet, updater, rateStore) = dependency
        
        let tick = NotificationCenter.default.rx.notification(Notification.Name.UIApplicationWillEnterForeground)
            .map { _ in }
            .startWith(())

        etherBalance = Observable.merge(tick, updater.refreshBalance).flatMap { _ -> Observable<Balance> in
            return geth.getBalance(address: wallet.address(), blockParameter: .pending).asObservable()
        }
        
        fiatBalance = Observable
            .combineLatest(etherBalance, rateStore.currentRate) { $0.calculateFiatBalance(rate: $1)}
    }
}
