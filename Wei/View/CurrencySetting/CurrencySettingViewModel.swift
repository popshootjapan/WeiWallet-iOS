//
//  CurrencySettingViewModel.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/06/28.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class CurrencySettingViewModel: InjectableViewModel {
    
    typealias Dependency = (
        CurrencyManagerProtocol
    )
    
    private let currencyManager: CurrencyManagerProtocol
    
    init(dependency: Dependency) {
        currencyManager = dependency
    }
    
    struct Input {
        let selectedIndexPath: Driver<IndexPath>
    }
    
    struct Output {
        let currencies: Driver<[(Currency, Bool)]>
    }
    
    func build(input: Input) -> Output {
        let currencies = Driver.just(Currency.all)
        
        let selectedCurrency = input.selectedIndexPath
            .withLatestFrom(currencies) { $1[$0.row] }
            .do(onNext: { [weak self] currency in
                self?.currencyManager.updateCurrency.onNext(currency)
            })
            .withLatestFrom(currencyManager.currency.asDriver(onErrorDriveWith: .empty()))
        
        return Output(currencies: Driver
            .combineLatest(currencies, selectedCurrency)
            .map { currencies, selectedCurrency in
                return currencies.map { ($0, $0 == selectedCurrency) }
            }
        )
    }
}
