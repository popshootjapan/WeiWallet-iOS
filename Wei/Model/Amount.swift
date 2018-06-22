//
//  Amount.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/06/19.
//  Copyright © 2018 yz. All rights reserved.
//

import EthereumKit

enum Amount {
    case ether(Ether)
    case fiat(Fiat)
    
    func valid() -> Bool {
        switch self {
        case .ether(let value):
            return value > 0
        case .fiat(let fiat):
            return fiat.value > 0
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
    
    func fiat() -> Decimal {
        switch self {
        case .ether(_):
            fatalError("needs acquired from amountInFiat")
        case .fiat(let fiat):
            return fiat.value
        }
    }
}
