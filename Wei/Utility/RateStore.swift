//
//  RateStore.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/12.
//  Copyright © 2018 popshoot All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol RateStoreProtocol {
    var currentRate: Observable<Price> { get }
}

final class RateStore: Injectable, RateStoreProtocol {
    
    typealias Dependency = (
        CacheProtocol,
        RateRepositoryProtocol,
        UpdaterProtocol,
        CurrencyManagerProtocol
    )
    
    let currentRate: Observable<Price>
    
    init(dependency: Dependency) {
        let (cache, repository, updater, currencyManager) = dependency
        
        let cachedRate = currencyManager.currency.flatMap { currency -> Observable<Price> in
            return cache.load(for: RateService.GetCurrentRate(currency: currency)).asObservable()
        }
        
        let tick = NotificationCenter.default.rx.notification(Notification.Name.UIApplicationWillEnterForeground)
            .map { _ in }
            .startWith(())
        
        let updatedRate = Observable
            .merge(tick, updater.refreshRate)
            .withLatestFrom(currencyManager.currency)
            .flatMap { currency -> Observable<Price> in
                return repository.getCurrentRate(currency: currency).asObservable()
            }
        
        currentRate = Observable.merge(cachedRate, updatedRate)
    }
}
