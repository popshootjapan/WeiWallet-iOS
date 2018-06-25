//
//  MockApplicationStoreTests.swift
//  WeiTests
//
//  Created by Ryo Fukuda on 2018/06/22.
//  Copyright © 2018 yz. All rights reserved.
//

import Quick
import Nimble
@testable import Wei

final class MockApplicationStoreTests: QuickSpec {
    
    override func spec() {
        
        var applicationStore: ApplicationStoreProtocol = MockApplicationStore()
        
        beforeEach {
            applicationStore.clearData()
        }
        
        describe("Test each properties' getter and setter") {
            context("Test seed") {
                it("value changes correctly") {
                    expect(applicationStore.seed).to(beNil())
                    
                    let seed = "seed"
                    applicationStore.seed = seed
                    expect(applicationStore.seed).to(equal(seed))
                }
            }
            
            context("Test mnemonic") {
                it("value changes correctly") {
                    expect(applicationStore.mnemonic).to(beNil())
                    
                    let mnemonic = "mnemonic"
                    applicationStore.mnemonic = mnemonic
                    expect(applicationStore.mnemonic).to(equal(mnemonic))
                }
            }
            
            context("Test access token") {
                it("value changes correctly") {
                    expect(applicationStore.accessToken).to(beNil())
                    
                    let accessToken = "accessToken"
                    applicationStore.accessToken = accessToken
                    expect(applicationStore.accessToken).to(equal(accessToken))
                }
            }
            
            context("Test isAlreadyBackup flag") {
                it("value changes correctly") {
                    expect(applicationStore.isAlreadyBackup).to(equal(false))
                    
                    let isAlreadyBackup = true
                    applicationStore.isAlreadyBackup = isAlreadyBackup
                    expect(applicationStore.isAlreadyBackup).to(equal(isAlreadyBackup))
                }
            }
            
            context("Test currency") {
                it("value changes correctly") {
                    expect(applicationStore.currency).to(beNil())
                    
                    let currency = Currency.jpy
                    applicationStore.currency = currency
                    expect(applicationStore.currency).to(equal(currency))
                }
            }
        }
    }
}
