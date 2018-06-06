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
    
    /// Manage a nonce value with both fetched nonce snd last nonce
    static func manage(_ fetchedNonce: Int) -> Int {
        guard let storedNonce = lastNonce else {
            lastNonce = fetchedNonce
            return fetchedNonce
        }
        
        let incrementedNonce = storedNonce + 1
        
        guard incrementedNonce < fetchedNonce else {
            lastNonce = fetchedNonce
            return fetchedNonce
        }
        
        lastNonce = incrementedNonce
        return incrementedNonce
    }
}
