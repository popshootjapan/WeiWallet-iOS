//
//  TransactionContext.swift
//  Wei
//
//  Created by omatty198 on 2018/04/09.
//  Copyright © 2018年 yz. All rights reserved.
//

import Foundation
import EthereumKit

enum Amount {
    case ether(Ether)
    case fiat(Int64)
    
    func valid() -> Bool {
        switch self {
        case .ether(let value):
            return value > 0
        case .fiat(let value):
            return value > 0
        }
    }
    
    func ether() -> Ether {
        switch self {
        case .ether(let value):
            return value
        case .fiat(_):
            fatalError("needs acquired from amountInEther")
        }
    }
    
    func fiat() -> Int64 {
        switch self {
        case .ether(_):
            fatalError("needs acquired from amountInFiat")
        case .fiat(let value):
            return value
        }
    }
}

struct TransactionContext {
    
    let address: String
    let fiatAmount: Amount
    let etherAmount: Amount
    let fiatFee: Amount
    let etherFee: Amount
    let gasPrice: Int
    let gasLimit: Int
    
    var isAmountValid: Bool {
        return fiatAmount.valid() && etherAmount.valid()
    }
    
    var isFeeValid: Bool {
        return fiatFee.valid() && etherFee.valid()
    }
    
    var isContextValid: Bool {
        return isAmountValid && isFeeValid && AddressValidator.validate(address)
    }
}
