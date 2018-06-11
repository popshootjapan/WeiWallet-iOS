//
//  NonceManagerTests.swift
//  WeiTests
//
//  Created by Ryo Fukuda on 2018/06/06.
//  Copyright © 2018 yz. All rights reserved.
//

import Quick
import Nimble
@testable import Wei

final class NonceManagerTests: QuickSpec {
    
    override func spec() {
        describe("Test NonceManager") {
            context("Test when just incrementing the nonce value") {
                beforeEach {
                    NonceManager.lastNonce = nil
                }
                
                it("will just be incremented") {
                    expect(NonceManager.manage(0))
                        .to(equal(0))
                    
                    expect(NonceManager.manage(1))
                        .to(equal(1))
                    
                    expect(NonceManager.manage(2))
                        .to(equal(2))
                    
                    expect(NonceManager.manage(3))
                        .to(equal(3))
                }
            }
            
            context("Test when sending ether constantly and nonce does not get updated") {
                beforeEach {
                    NonceManager.lastNonce = nil
                }
                
                it("will increment the nonce value using lastNonce") {
                    expect(NonceManager.manage(20))
                        .to(equal(20))
                    
                    expect(NonceManager.manage(20))
                        .to(equal(21))
                    
                    expect(NonceManager.manage(20))
                        .to(equal(22))
                    
                    expect(NonceManager.manage(20))
                        .to(equal(23))
                    
                    expect(NonceManager.manage(24))
                        .to(equal(24))
                }
            }
        }
    }
}
