//
//  MockRateRepositoryTests.swift
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

final class MockRateRepositoryTests: QuickSpec {
    
    override func spec() {
        let repository = MockRateRepository()
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        
        describe("Test MockRateRepository") {
            
            context("Test convertToFiat") {
                var fiat: TestableObserver<String>!
                
                beforeEach {
                    fiat = scheduler.createObserver(String.self)
                    
                    scheduler.scheduleAt(10) {
                        repository.convertToFiat(from: "1", to: .jpy).asObservable()
                            .map { $0.price }
                            .subscribe(fiat)
                            .disposed(by: disposeBag)
                    }
                    
                    scheduler.start()
                }
                
                it("returns the expected value") {
                    XCTAssertEqual(fiat.events, [
                        next(10, "1000.55"),
                        completed(10)
                    ])
                }
            }
            
            context("Test convertToEther") {
                var ether: TestableObserver<String>!
                
                beforeEach {
                    ether = scheduler.createObserver(String.self)
                    
                    scheduler.scheduleAt(10) {
                        repository.convertToEther(from: "1", to: .jpy).asObservable()
                            .map { $0.price }
                            .subscribe(ether)
                            .disposed(by: disposeBag)
                    }
                    
                    scheduler.start()
                }
                
                it("returns the expected value") {
                    XCTAssertEqual(ether.events, [
                        next(10, "1.5"),
                        completed(10)
                    ])
                }
            }
            
            context("Test getCurrentRate") {
                var rate: TestableObserver<String>!
                
                beforeEach {
                    rate = scheduler.createObserver(String.self)
                    
                    scheduler.scheduleAt(10) {
                        repository.getCurrentRate(currency: .jpy).asObservable()
                            .map { $0.price }
                            .subscribe(rate)
                            .disposed(by: disposeBag)
                    }
                    
                    scheduler.start()
                }
                
                it("returns the expected value") {
                    XCTAssertEqual(rate.events, [
                        next(10, "5000"),
                        completed(10)
                    ])
                }
            }
        }
    }
}
