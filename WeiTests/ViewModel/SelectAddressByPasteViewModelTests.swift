//
//  SelectAddressByPasteViewModelTests.swift
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

final class SelectAddressByPasteViewModelTests: QuickSpec {
    
    override func spec() {
        
        var viewModel: SelectAddressByPasteViewModel!
        var pasteByClipboardButtonDidTap: PublishSubject<Void>!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        
        beforeEach {
            scheduler = TestScheduler(initialClock: 0, resolution: 1.0, simulateProcessingDelay: false)
            SharingScheduler.mock(scheduler: scheduler) {
                viewModel = SelectAddressByPasteViewModel()
                pasteByClipboardButtonDidTap = PublishSubject()
                disposeBag = DisposeBag()
            }
        }
        
        describe("Test SelectAddressByPasteViewModel") {
            var isAddressValid: TestableObserver<Bool>!
            var pushSelectAmountViewController: TestableObserver<String>!
            
            beforeEach {
                SharingScheduler.mock(scheduler: scheduler) {
                    isAddressValid = scheduler.createObserver(Bool.self)
                    pushSelectAmountViewController = scheduler.createObserver(String.self)
                    
                    let output = viewModel.build(input: .init(
                        pasteByClipboardButtonDidTap: pasteByClipboardButtonDidTap.asDriver(onErrorDriveWith: .empty())
                    ))
                    
                    output
                        .isAddressValid
                        .drive(isAddressValid)
                        .disposed(by: disposeBag)
                    
                    output
                        .pushSelectAmountViewController
                        .drive(pushSelectAmountViewController)
                        .disposed(by: disposeBag)
                    
                    scheduler.scheduleAt(10) {
                        UIPasteboard.general.string = "0x000"
                        pasteByClipboardButtonDidTap.onNext(())
                    }
                    
                    scheduler.scheduleAt(20) {
                        UIPasteboard.general.string = "0x83f1caAdaBeEC2945b73087F803d404F054Cc2B7"
                        pasteByClipboardButtonDidTap.onNext(())
                    }
                    
                    scheduler.start()
                }
            }
            
            it("emits elements whether or not an address is valid") {
                XCTAssertEqual(isAddressValid.events, [
                    next(10, false),
                    next(20, true),
                ])
            }
            
            it("emits elements only when an address is valid") {
                XCTAssertEqual(pushSelectAmountViewController.events, [
                    next(20, "0x83f1caAdaBeEC2945b73087F803d404F054Cc2B7")
                ])
            }
        }
    }
}
