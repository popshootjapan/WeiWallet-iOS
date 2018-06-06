//
//  ApplicationStore.swift
//  Wei
//
//  Created by yuzushioh on 2018/03/15.
//  Copyright © 2018 popshoot. All rights reserved.
//

protocol ApplicationStoreProtocol {
    var seed: String? { get set }
    var mnemonic: String? { get set }
    var accessToken: String? { get set }
    var isAlreadyBackup: Bool { get set }
    
    func clearData()
}

final class ApplicationStore: ApplicationStoreProtocol, Injectable {
    
    typealias Dependency = (
        KeychainStore,
        CacheProtocol,
        LocalTransactionRepositoryProtocol
    )
    
    private let keychainStore: KeychainStore
    private let cache: CacheProtocol
    private let localTransactionRepository: LocalTransactionRepositoryProtocol
    
    init(dependency: Dependency) {
        (keychainStore, cache, localTransactionRepository)  = dependency
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
    
    func clearData() {
        keychainStore.clearKeychain()
        cache.clear()
        localTransactionRepository.deleteAllObjects()
    }
}
