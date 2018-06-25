//
//  RateStoreTests.swift
//  WeiTests
//
//  Created by Ryo Fukuda on 2018/06/25.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxTest
import Quick
@testable import Wei

final class RateStoreTests: QuickSpec {
    
    override func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        
        var localCurrency: Currency!
        var updater: UpdaterProtocol!
        var currencyManager: CurrencyManagerProtocol!
        var rateStore: RateStoreProtocol!
        
        beforeEach {
            scheduler = TestScheduler(initialClock: 0)
            disposeBag = DisposeBag()
            
            localCurrency = LocaleLanguage.preferred().currency()
            
            let cache = Cache()
            cache.clear()
            
            updater = MockUpdater()
            currencyManager = CurrencyManager(dependency: MockApplicationStore())
            
            rateStore = RateStore(dependency: (
                cache,
                MockRateRepository(),
                updater,
                currencyManager
            ))
        }
        
        describe("Test RateStore in jpy") {
            var rate: TestableObserver<Fiat>!
            
            beforeEach {
                rate = scheduler.createObserver(Fiat.self)
                
                rateStore
                    .currentRate
                    .subscribe(rate)
                    .disposed(by: disposeBag)
                
                scheduler.scheduleAt(10) {
                    currencyManager.updateCurrency.onNext(.jpy)
                }
                
                scheduler.scheduleAt(20) {
                    currencyManager.updateCurrency.onNext(.usd)
                }
                
                scheduler.scheduleAt(30) {
                    // currentRate will not emit because of `distinctUntilChanged()` operator.
                    updater.refreshRate.onNext(())
                }
                
                scheduler.start()
            }
            
            it("returns currency rate in Fiat model") {
                let expectedFirstValue = localCurrency == Currency.jpy ? Fiat.jpy(5000) : Fiat.usd(5000)
                XCTAssertEqual(rate.events, [
                    next(0, expectedFirstValue),
                    next(10, Fiat.jpy(5000)),
                    next(20, Fiat.usd(5000)),
                ])
            }
        }
    }
}
