//
//  BalanceStore.swift
//  Wei
//
//  Created by omatty198 on 2018/04/26.
//  Copyright © 2018年 popshoot All rights reserved.
//

import Foundation
import EthereumKit
import RxSwift
import RxCocoa

protocol BalanceStoreProtocol {
    var etherBalance: Observable<Balance> { get }
    var fiatBalance: Observable<Fiat> { get }
}

final class BalanceStore: Injectable, BalanceStoreProtocol {
    
    typealias Dependency = (
        GethRepositoryProtocol,
        WalletManagerProtocol,
        UpdaterProtocol,
        RateStoreProtocol,
        CacheProtocol
    )
    
    let etherBalance: Observable<Balance>
    let fiatBalance: Observable<Fiat>
    
    init(dependency: Dependency) {
        let (geth, wallet, updater, rateStore, cache) = dependency
        
        let tick = NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .map { _ in }
            .startWith(())

        let fetchedBalance = Observable.merge(tick, updater.refreshBalance).flatMap { _ -> Observable<Balance> in
            return geth.getBalance(address: wallet.address(), blockParameter: .pending).asObservable()
                .do(onNext: { cache.save($0, for: .transactionHistory) })
        }
        
        let cachedBalance = cache.load(type: Balance.self, for: .transactionHistory).asObservable()
        
        etherBalance = Observable.merge(cachedBalance, fetchedBalance)
        
        fiatBalance = Observable
            .combineLatest(etherBalance, rateStore.currentRate) { $0.calculateFiatBalance(fiatRate: $1) }
    }
}
