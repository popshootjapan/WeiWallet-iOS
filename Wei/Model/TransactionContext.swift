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
    
    var address: String
    var fiatAmount: Amount
    var etherAmount: Amount
    var fiatFee: Amount
    var etherFee: Amount
    
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
        return fiatFee.valid() && etherFee.valid()
    }
    
    var isContextValid: Bool {
        return isAddressValid && isAmountValid && isFeeValid
    }
}

extension TransactionContext {
    init(_ address: String, fiatAmount: Amount = .fiat(0), etherAmount: Amount = .ether(0), fiatFee: Amount = .fiat(0), etherFee: Amount = .ether(0)) {
        self.address = address
        self.fiatAmount = fiatAmount
        self.etherAmount = etherAmount
        self.fiatFee = fiatFee
        self.etherFee = etherFee
    }
}
