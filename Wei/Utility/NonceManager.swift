//
//  NonceManager.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/06/06.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation

struct NonceManager {
    
    /// Represents a nonce value used in the last transction
    static var lastNonce: Int?
    
    /// Manage a nonce value with both fetched nonce and last nonce
    static func manage(_ fetchedNonce: Int) -> Int {
        let nonce: Int
        if let storedNonce = lastNonce {
            nonce = storedNonce < fetchedNonce ? fetchedNonce : storedNonce + 1
        } else {
            nonce = fetchedNonce
        }
        lastNonce = nonce
        return nonce
    }
}
