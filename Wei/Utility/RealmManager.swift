//
//  RealmManager.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/06/04.
//  Copyright © 2018 yz. All rights reserved.
//

import RealmSwift
import RxSwift

protocol RealmManagerProtocol {
    var realm: Realm { get }
    var updateTick: PublishSubject<Void> { get }
}

final class RealmManager: RealmManagerProtocol {
    
    private static let schemaVersion: UInt64 = 1
    
    let realm: Realm
    let updateTick: PublishSubject<Void>
    let notificationToken: NotificationToken
    
    init() {
        RealmManager.migrateIfNeeded()
        
        let realm: Realm
        do {
            realm = try Realm()
        } catch {
            fatalError("Could not instantiate Realm: \(error)")
        }
        
        let updateTick = PublishSubject<Void>()
        let notificationToken = realm.observe { _, _ in
            updateTick.onNext(())
        }
        
        self.realm = realm
        self.updateTick = updateTick
        self.notificationToken = notificationToken
    }
    
    private static func migrateIfNeeded() {
        let config = Realm.Configuration(schemaVersion: schemaVersion)
        Realm.Configuration.defaultConfiguration = config
    }
}

