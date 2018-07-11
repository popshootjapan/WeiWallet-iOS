//
//  WalletManager.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/03/16.
//  Copyright © 2018 popshoot All rights reserved.
//

import RxSwift
import RxCocoa
import EthereumKit

protocol WalletManagerProtocol {
    func address() -> String
    func privateKey() -> String
    func sign(rawTransaction: RawTransaction) throws -> String
    func sign(message: String) throws -> String
}

final class WalletManager: WalletManagerProtocol, Injectable {
    
    let wallet: Wallet
    
    typealias Dependency = (
        ApplicationStoreProtocol
    )
    
    init(dependency: Dependency) {
        let applicationStore = dependency
        
        guard let seed = applicationStore.seed else {
            fatalError("Store seed before instantiating Wallet")
        }
        
        do {
            wallet = try Wallet(seed: Data(hex: seed), network: applicationStore.network, debugPrints: Environment.current.debugPrints)
        } catch let error {
            fatalError("Failed to instantiate Wallet: \(error.localizedDescription)")
        }
    }
    
    func address() -> String {
        return wallet.generateAddress()
    }
    
    func privateKey() -> String {
        return wallet.dumpPrivateKey()
    }
    
    func sign(rawTransaction: RawTransaction) throws -> String {
        return try wallet.sign(rawTransaction: rawTransaction)
    }
    
    func sign(message: String) throws -> String {
        return try wallet.sign(message: message)
    }
}
