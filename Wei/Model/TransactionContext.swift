//
//  TransactionContext.swift
//  Wei
//
//  Created by omatty198 on 2018/04/09.
//  Copyright © 2018年 popshoot All rights reserved.
//

import Foundation

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
