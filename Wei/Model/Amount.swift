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
