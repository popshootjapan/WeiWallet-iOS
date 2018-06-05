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
    
    /// Represents a gas price set for the app
    var gasPrice: Int { get set }
    
    /// Represents a gas limit set for the app
    var gasLimit: Int { get }
    
    /// Clears data in keychain
    func clearKeychain()
}

final class ApplicationStore: ApplicationStoreProtocol, Injectable {
    
    private let keychainStore: KeychainStore
    private var userDefaultsStore: UserDefaultsStoreProtocol
    
    typealias Dependency = (
        KeychainStore,
        UserDefaultsStoreProtocol
    )
    
    init(dependency: Dependency) {
        (keychainStore, userDefaultsStore) = dependency
    }
    
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
    
    var gasPrice: Int {
        get {
            return userDefaultsStore.gasPrice ?? Gas.safeLow.gasPrice
        }
        set {
            userDefaultsStore.gasPrice = newValue
        }
    }
    
    var gasLimit: Int {
        return Gas.safeLow.gasLimit
    }
    
    func clearKeychain() {
        seed = nil
        mnemonic = nil
        accessToken = nil
        
        isAlreadyBackup = false
        keychainStore[.isAlreadyBackup] = nil
    }
}
