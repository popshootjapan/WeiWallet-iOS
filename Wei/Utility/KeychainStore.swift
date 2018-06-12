//
//  KeychainStore.swift
//  Wei
//
//  Created by yuzushioh on 2018/03/15.
//  Copyright © 2018 popshoot. All rights reserved.
//

import KeychainAccess

final class KeychainStore {
    enum Service: String {
        case seed = "com.popshoot.seed"
        case mnemonic = "com.popshoot.mnemonic"
        case accessToken = "com.popshoot.accessToken"
        case isAlreadyBackup = "com.popshoot.isAlreadyBackup"
    }
    
    private let environment: Environment
    
    init(environment: Environment) {
        self.environment = environment
    }
    
    private static var accessGroup: String {
        guard let prefix = Bundle.main.object(forInfoDictionaryKey: "AppIdentifierPrefix") as? String else {
            fatalError("AppIdentifierPrefix is not found in Info.plist")
        }
        return prefix + Environment.current.appGroupID
    }
    
    private static func keychain(forService service: Service) -> Keychain {
        return Keychain(service: service.rawValue, accessGroup: accessGroup)
    }
    
    subscript(service: Service) -> String? {
        get {
            return KeychainStore.keychain(forService: service)[environment.appGroupID]
        }
        set {
            KeychainStore.keychain(forService: service)[environment.appGroupID] = newValue
        }
    }
    
    func clearKeychain() {
        self[.seed] = nil
        self[.mnemonic] = nil
        self[.accessToken] = nil
        self[.isAlreadyBackup] = nil
    }
}
