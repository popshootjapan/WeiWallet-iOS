//
//  MockAPIClientTests.swift
//  WeiTests
//
//  Created by Ryo Fukuda on 2018/06/21.
//  Copyright © 2018 yz. All rights reserved.
//

import Quick
import RxSwift
import RxCocoa
import RxTest
@testable import Wei

final class MockAPIClientTests: QuickSpec {
    
    override func spec() {
        
        var mockClient: MockAPIClient!
        var disposeBag: DisposeBag!
        var scheduler: TestScheduler!
        
        beforeEach {
            scheduler = TestScheduler(initialClock: 0)
            disposeBag = DisposeBag()
            mockClient = MockAPIClient()
        }
        
        describe("Execute GetAppStatus") {
            var forceUpdates: TestableObserver<Bool>!
            var isUnderMaintenance: TestableObserver<Bool>!
            
            beforeEach {
                forceUpdates = scheduler.createObserver(Bool.self)
                isUnderMaintenance = scheduler.createObserver(Bool.self)
                
                scheduler.scheduleAt(10) {
                    let response = mockClient.response(from: AppStatusService.GetAppStatus()).asObservable()
                        
                    response
                        .map { $0.forceUpdates }
                        .subscribe(forceUpdates)
                        .disposed(by: disposeBag)
                    
                    response
                        .map { $0.isUnderMaintenance }
                        .subscribe(isUnderMaintenance)
                        .disposed(by: disposeBag)
                }
                
                scheduler.start()
            }
            
            it("Fetches app status") {
                XCTAssertEqual(forceUpdates.events, [
                    next(10, false),
                    completed(10)
                ])
                
                XCTAssertEqual(isUnderMaintenance.events, [
                    next(10, false),
                    completed(10)
                ])
            }
        }
    }

}
