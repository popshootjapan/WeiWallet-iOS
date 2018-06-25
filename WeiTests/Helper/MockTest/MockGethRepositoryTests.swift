//
//  MockGethRepositoryTests.swift
//  WeiTests
//
//  Created by Ryo Fukuda on 2018/06/21.
//  Copyright © 2018 yz. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxCocoa
import RxTest
import EthereumKit

final class MockGethRepositoryTests: QuickSpec {
    
    override func spec() {
        
        var gethRepository: MockGethRepository!
        var disposeBag: DisposeBag!
        var scheduler: TestScheduler!
        
        beforeEach {
            scheduler = TestScheduler(initialClock: 0)
            disposeBag = DisposeBag()
            gethRepository = MockGethRepository()
        }
        
        describe("Execute getGasPrice") {
            var gasPrice: TestableObserver<Wei>!
            
            beforeEach {
                gasPrice = scheduler.createObserver(Wei.self)
                
                scheduler.scheduleAt(10) {
                    gethRepository.getGasPrice().asObservable()
                        .subscribe(gasPrice)
                        .disposed(by: disposeBag)
                }
                
                scheduler.start()
            }
            
            it("Fetches gas price") {
                XCTAssertEqual(gasPrice.events, [
                    next(10, Wei(100)),
                    completed(10)
                ])
            }
        }
        
        describe("Execute getBalance") {
            var balance: TestableObserver<Wei>!
            
            beforeEach {
                balance = scheduler.createObserver(Wei.self)
                
                scheduler.scheduleAt(10) {
                    gethRepository.getBalance(address: "", blockParameter: .latest).asObservable()
                        .map { $0.wei }
                        .subscribe(balance)
                        .disposed(by: disposeBag)
                }
                
                scheduler.start()
            }
            
            it("fetches balance") {
                XCTAssertEqual(balance.events, [
                    next(10, Wei(100)),
                    completed(10)
                ])
            }
        }
        
        describe("Execute getTransactionCount") {
            var nonce: TestableObserver<Int>!
            
            beforeEach {
                nonce = scheduler.createObserver(Int.self)
                
                scheduler.scheduleAt(10) {
                    gethRepository.getTransactionCount(address: "", blockParameter: .latest).asObservable()
                        .subscribe(nonce)
                        .disposed(by: disposeBag)
                }
                
                scheduler.start()
            }
            
            it("fetches transaction count") {
                XCTAssertEqual(nonce.events, [
                    next(10, 10),
                    completed(10)
                ])
            }
        }
        
        describe("Execute sendRawTransaction") {
            var id: TestableObserver<String>!
            
            beforeEach {
                id = scheduler.createObserver(String.self)
                
                scheduler.scheduleAt(10) {
                    gethRepository.sendRawTransaction(rawTransaction: "").asObservable()
                        .map { $0.id }
                        .subscribe(id)
                        .disposed(by: disposeBag)
                }
                
                scheduler.start()
            }
            
            it("returns transaction id which is a tx hash") {
                XCTAssertEqual(id.events, [
                    next(10, "id"),
                    completed(10)
                ])
            }
        }
        
        describe("Execute getTransactions") {
            var transactionCount: TestableObserver<Int>!
            
            beforeEach {
                transactionCount = scheduler.createObserver(Int.self)
                
                scheduler.scheduleAt(10) {
                    gethRepository.getTransactions(address: "").asObservable()
                        .map { $0.elements.count }
                        .subscribe(transactionCount)
                        .disposed(by: disposeBag)
                }
                
                scheduler.start()
            }
            
            it("returns transactions") {
                XCTAssertEqual(transactionCount.events, [
                    next(10, 0),
                    completed(10)
                ])
            }
        }
    }
}
