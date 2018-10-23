//
//  UserDefaultsStore.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/06/13.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation

protocol UserDefaultsStoreProtocol {
    
    /// Represents a user's currency
    var currency: String? { get set }
    
    /// Represents a current network
    var network: String? { get set }
    
    /// Represents a custom private network endpoint
    var privateNetworkEndpoint: String? { get set }
    
    /// Represents a current chainID (used only in private network)
    var chainID: Int { get set }
    
    /// Represents a flag whether or not a private network is used for test case
    var testUse: Bool { get set }
    
    /// Represents a gas price
    var gasPrice: Int? { get set }
    
    /// Removes all data in user defaults
    func removeAll()
}

final class UserDefaultsStore: UserDefaultsStoreProtocol {
    
    private let backend: UserDefaults
    private let environment: Environment
    
    init(environment: Environment) {
        guard let backend = UserDefaults(suiteName: environment.appGroupID) else {
            fatalError("Could not instantiate user defaults with suite name \(environment.appGroupID)")
        }
        self.backend = backend
        self.environment = environment
    }
    
    enum Key: String {
        case currency
        case network
        case chainID
        case privateNetworkEndpoint
        case testUse
        case gasPrice
    }
    
    var currency: String? {
        get {
            return value(for: .currency)
        }
        set {
            setValue(newValue, for: .currency)
        }
    }
    
    var network: String? {
        get {
            return value(for: .network)
        }
        set {
            setValue(newValue, for: .network)
        }
    }
    
    var privateNetworkEndpoint: String? {
        get {
            return value(for: .privateNetworkEndpoint)
        }
        set {
            setValue(newValue, for: .privateNetworkEndpoint)
        }
    }
    
    var chainID: Int {
        get {
            return value(for: .chainID) ?? 0
        }
        set {
            setValue(newValue, for: .chainID)
        }
    }
    
    var testUse: Bool {
        get {
            return value(for: .testUse) ?? true
        }
        set {
            setValue(newValue, for: .testUse)
        }
    }
    
    var gasPrice: Int? {
        get {
            return value(for: .gasPrice)
        }
        set {
            setValue(newValue, for: .gasPrice)
        }
    }
    
    func removeAll() {
        backend.removePersistentDomain(forName: environment.appGroupID)
    }
    
    private func value<T>(of type: T.Type = T.self, for key: Key) -> T? {
        switch T.self {
        case _ as URL.Type:
            return backend.url(forKey: key.rawValue) as? T
        default:
            return backend.object(forKey: key.rawValue) as? T
        }
    }
    
    private func setValue(_ value: Any?, for key: Key) {
        switch value {
        case let url as URL:
            backend.set(url, forKey: key.rawValue)
        default:
            backend.set(value, forKey: key.rawValue)
        }
    }
}
