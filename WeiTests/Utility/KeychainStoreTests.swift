//
//  KeychainStoreTests.swift
//  WeiTests
//
//  Created by yuzushioh on 2018/05/18.
//  Copyright © 2018 popshoot All rights reserved.
//

import Quick
import Nimble
import Swinject
@testable import Wei

final class KeychainStoreTests: QuickSpec {
    
    override func spec() {
        
        let keychanStore = Container.shared.resolve(KeychainStore.self)!
        
        var seed: String? {
            get {
                return keychanStore[.seed]
            }
            set {
                keychanStore[.seed] = newValue
            }
        }
        
        var mnemonic: String? {
            get {
                return keychanStore[.mnemonic]
            }
            set {
                keychanStore[.mnemonic] = newValue
            }
        }
        
        var accessToken: String? {
            get {
                return keychanStore[.accessToken]
            }
            set {
                keychanStore[.accessToken] = newValue
            }
        }
        
        var isAlreadyBackup: Bool {
            get {
                return keychanStore[.isAlreadyBackup] != nil
            }
            set {
                let key = newValue ? "" : nil
                keychanStore[.isAlreadyBackup] = key
            }
        }
        
        var storedSeed: String!
        var storedMnemonic: String!
        var storedAccessToken: String!
        
        beforeEach {
            storedSeed = seed
            seed = nil
            storedMnemonic = mnemonic
            mnemonic = nil
            storedAccessToken = accessToken
            accessToken = nil
            isAlreadyBackup = false
        }
        
        afterEach {
            seed = storedSeed
            mnemonic = storedMnemonic
            accessToken = storedAccessToken
            isAlreadyBackup = false
        }
        
        describe("Test KeychainStore") {
            
            it("Tests seed property") {
                expect(seed).to(beNil())
                
                seed = "seed"
                expect(seed).to(equal("seed"))
                
                seed = "seed updated"
                expect(seed).to(equal("seed updated"))
                
                seed = nil
                expect(seed).to(beNil())
            }
            
            it("Tests mnemonic property") {
                expect(mnemonic).to(beNil())
                
                mnemonic = "mnemonic"
                expect(mnemonic).to(equal("mnemonic"))
                
                mnemonic = "mnemonic updated"
                expect(mnemonic).to(equal("mnemonic updated"))
                
                mnemonic = nil
                expect(mnemonic).to(beNil())
            }
            
            it("Tests access token property") {
                expect(accessToken).to(beNil())
                
                accessToken = "accessToken"
                expect(accessToken).to(equal("accessToken"))
                
                accessToken = "accessToken updated"
                expect(accessToken).to(equal("accessToken updated"))
                
                accessToken = nil
                expect(accessToken).to(beNil())
            }
            
            it("Tests isAlreadyBackup property") {
                expect(isAlreadyBackup).to(equal(false))
                
                isAlreadyBackup = true
                expect(isAlreadyBackup).to(equal(true))
                
                isAlreadyBackup = false
                expect(isAlreadyBackup).to(equal(false))
            }
        }
    }
}
