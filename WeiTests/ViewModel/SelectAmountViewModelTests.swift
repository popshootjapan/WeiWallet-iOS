//
//  SelectAmountViewModelTests.swift
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

final class SelectAmountViewModelTests: QuickSpec {
    
    override func spec() {
        var viewModel: SelectAmountViewModel!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        
        beforeEach {
            scheduler = TestScheduler(initialClock: 0, resolution: 1.0, simulateProcessingDelay: false)
            
            SharingScheduler.mock(scheduler: scheduler) {
                
            }
        }
    }
}
