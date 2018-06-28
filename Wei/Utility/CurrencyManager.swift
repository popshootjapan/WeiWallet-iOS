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
    var currency: Driver<Currency> { get }
    
    /// Updates user's currency
    var updateCurrency: PublishSubject<Currency> { get }
}

final class CurrencyManager: CurrencyManagerProtocol, Injectable {
    
    typealias Dependency = (
        ApplicationStoreProtocol
    )
    
    let updateCurrency = PublishSubject<Currency>()
    let currency: Driver<Currency>
    
    init(dependency: Dependency) {
        var userDefaultsStore = dependency
        
        currency = updateCurrency
            .distinctUntilChanged()
            .do(onNext: { userDefaultsStore.currency = $0 })
            .startWith(userDefaultsStore.currency ?? LocaleLanguage.preferred().currency())
            .asDriver(onErrorDriveWith: .empty())
    }
}
