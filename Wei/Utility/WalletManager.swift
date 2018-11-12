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
    
    func personalSign(message: String) throws -> String
    
    func personalSign(hex: String) throws -> String
}

final class WalletManager: WalletManagerProtocol, Injectable {
    
    let wallet: Wallet
    
    typealias Dependency = (
        ApplicationStoreProtocol
    )
    
    init(dependency: Dependency) {
        var applicationStore = dependency
        
        let seed: Data
        if let storedSeed = applicationStore.seed {
            seed = Data(hex: storedSeed)
        } else {
            let mnemonic = Mnemonic.create()
            
            do {
                seed = try Mnemonic.createSeed(mnemonic: mnemonic)
            } catch let error {
                fatalError("failed to generate seed, error: \(error.localizedDescription)")
            }
            
            applicationStore.mnemonic = mnemonic.joined(separator: " ")
            applicationStore.seed = seed.toHexString()
        }
        
        do {
            wallet = try Wallet(seed: seed, network: applicationStore.network, debugPrints: Environment.current.debugPrints)
        } catch let error {
            fatalError("Failed to instantiate Wallet: \(error.localizedDescription)")
        }
    }
    
    func address() -> String {
        return wallet.address()
    }
    
    func privateKey() -> String {
        return wallet.privateKey().toHexString()
    }
    
    func sign(rawTransaction: RawTransaction) throws -> String {
        return try wallet.sign(rawTransaction: rawTransaction)
    }
    
    func personalSign(message: String) throws -> String {
        return try wallet.personalSign(message: message)
    }
    
    func personalSign(hex: String) throws -> String {
        return try wallet.personalSign(hex: hex)
    }
}
