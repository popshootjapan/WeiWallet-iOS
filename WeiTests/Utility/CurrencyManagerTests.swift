//
//  CurrencyManagerTests.swift
//  WeiTests
//
//  Created by Ryo Fukuda on 2018/06/22.
//  Copyright © 2018 yz. All rights reserved.
//

import RxSwift
import RxCocoa
import RxTest
import Quick
@testable import Wei

final class CurrencyManagerTests: QuickSpec {
    
    override func spec() {
        
        var currencyManager: CurrencyManagerProtocol!
        var localCurrency: Currency!
        
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        
        beforeEach {
            currencyManager = CurrencyManager(dependency: (
                MockApplicationStore()
            ))
            
            localCurrency = LocaleLanguage.preferred().currency()
            
            scheduler = TestScheduler(initialClock: 0)
            disposeBag = DisposeBag()
        }
        
        describe("Test CurrencyManager") {
            var currency: TestableObserver<Currency>!
            
            beforeEach {
                currency = scheduler.createObserver(Currency.self)
                
                currencyManager
                    .currency
                    .asObservable()
                    .subscribe(currency)
                    .disposed(by: disposeBag)
                
                scheduler.scheduleAt(10) {
                    currencyManager.updateCurrency.onNext(.jpy)
                }
                
                scheduler.scheduleAt(20) {
                    currencyManager.updateCurrency.onNext(.usd)
                }
                
                scheduler.start()
            }
            
            it("changes currency value") {
                XCTAssertEqual(currency.events, [
                    next(0, localCurrency),
                    next(10, Currency.jpy),
                    next(20, Currency.usd)
                ])
            }
        }
    }
}
