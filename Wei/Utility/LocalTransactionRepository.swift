//
//  LocalTransactionRepository.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/06/04.
//  Copyright © 2018 yz. All rights reserved.
//

import RxSwift
import RealmSwift

protocol LocalTransactionRepositoryProtocol {
    
    /// it will emit when a value in realm data base get changed.
    var updateTick: Observable<Void> { get }
    
    /// add local transaction object in realm database
    func add(_ object: LocalTransaction, update: Bool)
    
    /// Returns a object which matches the primaryKey
    func object(for primaryKey: Any) -> LocalTransaction?
    
    /// Returns all local transaction objects
    func objects() -> [LocalTransaction]
    
    /// Delete local transaction which matches the primaryKey
    func delete(primaryKey: Any)
    
    /// Delete all local transaction objects
    func deleteAllObjects()
}

extension LocalTransactionRepositoryProtocol {
    func add(_ object: LocalTransaction) {
        add(object, update: true)
    }
}

final class LocalTransactionRepository: Injectable, LocalTransactionRepositoryProtocol {
    
    typealias Dependency = (
        RealmManagerProtocol
    )
    
    private let realmManager: RealmManagerProtocol
    
    init(dependency: Dependency) {
        realmManager = dependency
    }
    
    private var realm: Realm {
        return realmManager.realm
    }
    
    var updateTick: Observable<Void> {
        return realmManager.updateTick.asObservable()
    }
    
    func add(_ object: LocalTransaction, update: Bool) {
        write {
            realm.add(object, update: update)
        }
    }
    
    func object(for primaryKey: Any) -> LocalTransaction? {
        return realm.object(ofType: LocalTransaction.self, forPrimaryKey: primaryKey)
    }
    
    func objects() -> [LocalTransaction] {
        return Array(realm.objects(LocalTransaction.self))
    }
    
    func delete(primaryKey: Any) {
        guard let object = object(for: primaryKey) else {
            return
        }
        
        write {
            realm.delete(object)
        }
    }
    
    func deleteAllObjects() {
        write {
            realm.delete(objects())
        }
    }
    
    private func write(_ block: () -> Void) {
        if realm.isInWriteTransaction {
            block()
            return
        }
        
        do {
            try realm.write {
                block()
            }
        } catch {
            fatalError("Realm Error")
        }
    }

}
