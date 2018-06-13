//
//  CurrencyManager.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/06/13.
//  Copyright © 2018 yz. All rights reserved.
//

import RxSwift
import RxCocoa

protocol CurrencyManagerProtocol {
    
    /// Represents user's currency
    var currency: Observable<Currency> { get }
    
    /// Updates user's currency
    var updateCurrency: PublishSubject<Currency> { get }
}

final class CurrencyManager: CurrencyManagerProtocol, Injectable {
    
    typealias Dependency = (
        ApplicationStoreProtocol
    )
    
    let updateCurrency = PublishSubject<Currency>()
    let currency: Observable<Currency>
    
    init(dependency: Dependency) {
        var userDefaulsStore = dependency
        
        currency = updateCurrency
            .do(onNext: { userDefaulsStore.currency = $0 })
            .startWith(userDefaulsStore.currency ?? Locale.preferred().currency())
    }
}
