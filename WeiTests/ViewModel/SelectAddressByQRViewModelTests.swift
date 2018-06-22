//
//  SelectAddressByQRViewModelTests.swift
//  WeiTests
//
//  Created by Ryo Fukuda on 2018/06/22.
//  Copyright © 2018 yz. All rights reserved.
//

import Quick
import RxSwift
import RxCocoa
import RxTest
@testable import Wei

final class SelectAddressByQRViewModelTests: QuickSpec {
    
    override func spec() {
        
        var viewModel: SelectAddressByQRViewModel!
        var addressInput: PublishSubject<String>!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        
        beforeEach {
            scheduler = TestScheduler(initialClock: 0, resolution: 1.0, simulateProcessingDelay: false)
            SharingScheduler.mock(scheduler: scheduler) {
                viewModel = SelectAddressByQRViewModel()
                addressInput = PublishSubject()
                disposeBag = DisposeBag()
            }
        }
        
        describe("Test SelectAddressByQRViewModel") {
            var isAddressValid: TestableObserver<Bool>!
            var pushSelectAmountViewController: TestableObserver<String>!
            
            beforeEach {
                SharingScheduler.mock(scheduler: scheduler) {
                    isAddressValid = scheduler.createObserver(Bool.self)
                    pushSelectAmountViewController = scheduler.createObserver(String.self)
                    
                    let output = viewModel.build(input: .init(
                        address: addressInput.asDriver(onErrorDriveWith: .empty())
                    ))
                    
                    output
                        .isAddressValid
                        .map { _ in true }
                        .drive(isAddressValid)
                        .disposed(by: disposeBag)
                    
                    output
                        .pushSelectAmountViewController
                        .drive(pushSelectAmountViewController)
                        .disposed(by: disposeBag)
                    
                    scheduler.scheduleAt(10) {
                        addressInput.onNext("111111")
                    }
                    
                    scheduler.scheduleAt(20) {
                        addressInput.onNext("0x99999999")
                    }
                    
                    scheduler.scheduleAt(30) {
                        addressInput.onNext("0x83f1caAdaBeEC2945b73087F803d404F054Cc2B7")
                    }
                    
                    scheduler.start()
                }
            }
            
            it("emits element when invalid") {
                XCTAssertEqual(isAddressValid.events, [
                    next(10, true),
                    next(20, true),
                ])
            }
            
            it("emits element when address is valid") {
                XCTAssertEqual(pushSelectAmountViewController.events, [
                    next(30, "0x83f1caAdaBeEC2945b73087F803d404F054Cc2B7")
                ])
            }
        }
    }
}
