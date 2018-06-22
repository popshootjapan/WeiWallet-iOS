//
//  Fiat.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/06/19.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation

enum Fiat: Equatable {
    case jpy(Int64)
    case usd(Decimal)
    
    var value: Decimal {
        switch self {
        case .jpy(let value):
            return Decimal(value)
        case .usd(let value):
            return value
        }
    }
    
    static func == (lhs: Fiat, rhs: Fiat) -> Bool {
        switch (lhs, rhs) {
        case (.jpy(let lhs), .jpy(let rhs)):
            return lhs == rhs
        case (.usd(let lhs), .usd(let rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
}
