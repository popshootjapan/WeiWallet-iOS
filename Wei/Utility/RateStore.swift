//
//  RateStore.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/12.
//  Copyright © 2018 yz. All rights reserved.
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
        UpdaterProtocol
    )
    
    let currentRate: Observable<Price>
    
    init(dependency: Dependency) {
        let (cache, repository, updater) = dependency
        
        let cachedRate = cache.load(for: RateService.GetCurrentRate(currency: .jpy)).asObservable()
        
        let tick = NotificationCenter.default.rx.notification(Notification.Name.UIApplicationWillEnterForeground)
            .map { _ in }
            .startWith(())
        
        let updatedRate = Observable.merge(tick, updater.refreshRate).flatMap { _ -> Observable<Price> in
            return repository.getCurrentRate(currency: .jpy).asObservable()
        }
        
        currentRate = Observable.merge(cachedRate, updatedRate)
    }
}
