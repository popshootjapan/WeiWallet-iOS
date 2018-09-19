//
//  MockApplicationStore.swift
//  WeiTests
//
//  Created by Ryo Fukuda on 2018/06/22.
//  Copyright © 2018 yz. All rights reserved.
//

@testable import Wei

final class MockApplicationStore: ApplicationStoreProtocol {
    
    var seed: String? = "3779b041fab425e9c0fd55846b2a03e9a388fb12784067bd8ebdb464c2574a05bcc7a8eb54d7b2a2c8420ff60f630722ea5132d28605dbc996c8ca7d7a8311c0"
    
    var mnemonic: String? = "abandon amount liar amount expire adjust cage candy arch gather drum buyer"
    
    var accessToken: String? = "token"
    
    var isAlreadyBackup: Bool = false
    
    var currency: Currency? = nil
    
    var network: Network = Network.current
    
    var gasPrice: Int = 0
    
    func clearData() {
        seed = nil
        mnemonic = nil
        accessToken = nil
        isAlreadyBackup = false
        currency = nil
        network = Network.current
        gasPrice = 0
    }
}
