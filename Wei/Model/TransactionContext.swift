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
        return AddressValidator(address: address).validate()
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
