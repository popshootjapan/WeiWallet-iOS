//
//  RateStore.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/12.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol RateStoreProtocol {
    var currentRate: Observable<Fiat> { get }
}

final class RateStore: Injectable, RateStoreProtocol {
    
    typealias Dependency = (
        CacheProtocol,
        RateRepositoryProtocol,
        UpdaterProtocol,
        CurrencyManagerProtocol
    )
    
    let currentRate: Observable<Fiat>
    
    init(dependency: Dependency) {
        let (cache, repository, updater, currencyManager) = dependency
        let currency = currencyManager.currency.asObservable()
        
        let cachedRate = currency.flatMap { currency -> Observable<Price> in
            return cache.load(for: RateService.GetCurrentRate(currency: currency)).asObservable()
        }
        
        let tick = NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .map { _ in }
            .startWith(())
        
        let updatedRate = Observable
            .merge(tick, updater.refreshRate)
            .withLatestFrom(currency)
            .flatMap { currency -> Observable<Price> in
                return repository.getCurrentRate(currency: currency).asObservable()
            }
        
        currentRate = Observable
            .combineLatest(Observable.merge(cachedRate, updatedRate), currency)
            .flatMap { rate, currency -> Observable<Fiat> in
                guard let doubleValue = Double(rate.price) else {
                    return Observable.empty()
                }
                
                switch currency {
                case .jpy:
                    return Observable.just(Fiat.jpy(Int64(doubleValue)))
                case .usd:
                    return Observable.just(Fiat.usd(Decimal(doubleValue)))
                }
            }
            .distinctUntilChanged()
    }
}
