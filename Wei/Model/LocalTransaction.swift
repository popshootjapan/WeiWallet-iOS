//
//  LocalTransaction.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/06/04.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation
import RealmSwift

final class LocalTransaction: Object {
    
    override class func primaryKey() -> String? {
        return "txID"
    }
    
    @objc dynamic var txID: String = ""
    @objc dynamic var from: String = ""
    @objc dynamic var to: String = ""
    @objc dynamic var value: String = ""
    @objc dynamic var gasPrice: Int = 0
    @objc dynamic var gasLimit: Int = 0
    @objc dynamic var date: Int64 = 0
}
