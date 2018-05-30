//
//  WalletManager.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/03/16.
//  Copyright © 2018 yz. All rights reserved.
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
        
        let seedString: String?
        #if DEBUG
            if applicationStore.seed == nil {
                seedString = nil
            } else {
                seedString = "e804433e7c8228bb097c1801d3a8121fecd6bf07c5133956b53bc621887821be8e61a247b596bfeb1e274f69e5cb11b71b4bcd3696bcdc14cca3a09e54b18668"
            }
        #else
            seedString = applicationStore.seed
        #endif
        
        guard let seed = seedString else {
            fatalError("Store seed before instantiating Wallet")
        }
        
        do {
            wallet = try Wallet(seed: Data(hex: seed), network: Network.currenct, debugPrints: Environment.current.debugPrints)
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
