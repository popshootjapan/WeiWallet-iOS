//
//  UserDefaultsStore.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/06/06.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation

protocol UserDefaultsStoreProtocol {
    var gasPrice: Int? { get set }
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
        case gasPrice
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
