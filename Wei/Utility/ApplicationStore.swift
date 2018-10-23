//
//  ApplicationStore.swift
//  Wei
//
//  Created by yuzushioh on 2018/03/15.
//  Copyright © 2018 popshoot. All rights reserved.
//

protocol ApplicationStoreProtocol {
    
    /// Represents user's master seed
    var seed: String? { get set }
    
    /// Represents user's mnemonic backup phrase
    var mnemonic: String? { get set }
    
    /// Represents user's access token for wei server
    var accessToken: String? { get set }
    
    /// Represents a flag whether user has done backup
    var isAlreadyBackup: Bool { get set }
    
    /// Represents a user's currency
    var currency: Currency? { get set }
    
    /// Represents a current network user is using
    var network: Network { get set }
    
    /// Represents a custom private network endpoint
    var privateNetworkEndpoint: String? { get set }
    
    /// Represents a gas price
    var gasPrice: Int { get set }
    
    /// Clears data in keychain
    func clearData()
}

final class ApplicationStore: ApplicationStoreProtocol, Injectable {
    
    typealias Dependency = (
        KeychainStore,
        CacheProtocol,
        LocalTransactionRepositoryProtocol,
        UserDefaultsStoreProtocol
    )
    
    private let keychainStore: KeychainStore
    private let cache: CacheProtocol
    private let localTransactionRepository: LocalTransactionRepositoryProtocol
    private var userDefaultsStore: UserDefaultsStoreProtocol
    
    init(dependency: Dependency) {
        (keychainStore, cache, localTransactionRepository, userDefaultsStore)  = dependency
    }
    
    // MARK: - Stores in Keychain
    
    var seed: String? {
        get {
            return keychainStore[.seed]
        }
        set {
            keychainStore[.seed] = newValue
        }
    }
    
    var mnemonic: String? {
        get {
            return keychainStore[.mnemonic]
        }
        set {
            keychainStore[.mnemonic] = newValue
        }
    }
    
    var accessToken: String? {
        get {
            return keychainStore[.accessToken]
        }
        set {
            keychainStore[.accessToken] = newValue
        }
    }
    
    var isAlreadyBackup: Bool {
        get {
            return keychainStore[.isAlreadyBackup] != nil
        }
        set {
            keychainStore[.isAlreadyBackup] = "backup.wei"
        }
    }
    
    // MARK: - Stores in UserDefaults
    
    var currency: Currency? {
        get {
            guard let currencyString = userDefaultsStore.currency,
                let currency = Currency(rawValue: currencyString) else {
                    return nil
            }
            return currency
        }
        set {
            userDefaultsStore.currency = newValue?.rawValue
        }
    }
    
    var network: Network {
        get {
            guard let networkName = userDefaultsStore.network else {
                return Network.current
            }
            
            let network: Network?
            switch networkName {
            case "main", "ropsten", "kovan":
                network = Network(name: networkName)
            case "private":
                network = Network(name: networkName, chainID: userDefaultsStore.chainID, testUse: userDefaultsStore.testUse)
            default:
                network = nil
            }
            
            guard let storedNetwork = network else {
                return Network.current
            }
            
            return storedNetwork
        }
        set {
            switch newValue {
            case .mainnet:
                userDefaultsStore.network = "main"
            case .kovan:
                userDefaultsStore.network = "kovan"
            case .ropsten:
                userDefaultsStore.network = "ropsten"
            case .private(let chainID, let testUse):
                userDefaultsStore.network = "private"
                userDefaultsStore.chainID = chainID
                userDefaultsStore.testUse = testUse
            }
        }
    }
    
    var privateNetworkEndpoint: String? {
        get {
            return userDefaultsStore.privateNetworkEndpoint
        }
        set {
            userDefaultsStore.privateNetworkEndpoint = newValue
        }
    }
    
    var gasPrice: Int {
        get {
            return userDefaultsStore.gasPrice ?? Gas.normalGasPriceInGWei
        }
        set {
            userDefaultsStore.gasPrice = newValue
        }
    }
    
    func clearData() {
        keychainStore.clearKeychain()
        cache.clear()
        localTransactionRepository.deleteAllObjects()
    }
}
