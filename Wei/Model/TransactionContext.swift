//
//  TransactionContext.swift
//  Wei
//
//  Created by omatty198 on 2018/04/09.
//  Copyright © 2018年 popshoot All rights reserved.
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
    let etherAmount: Amount
    let fiatAmount: Amount
    let fiatFee: Amount
    
    var isAddressValid: Bool {
        let isAddressNotEmpty = !address.isEmpty
        let isValidLength = address.count == 42
        let isStartWith0x = address.hasPrefix("0x")
        return isAddressNotEmpty && isValidLength && isStartWith0x
    }
    
    var isAmountValid: Bool {
        return fiatAmount.valid() && etherAmount.valid()
    }
    
    var isFeeValid: Bool {
        return fiatFee.valid()
    }
    
    var isContextValid: Bool {
        return isAddressValid && isAmountValid && isFeeValid
    }
}

extension TransactionContext {
    init(address: String) {
        self.address = address
        self.etherAmount = .ether(0)
        self.fiatAmount = .fiat(0)
        self.fiatFee = .fiat(0)
    }
}
