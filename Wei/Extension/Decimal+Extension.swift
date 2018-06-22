//
//  Decimal+Extension.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/06/18.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation

extension Decimal {
    func toInt64() -> Int64 {
        return NSDecimalNumber(decimal: self).int64Value
    }
}

extension Decimal {
    func round(scale: Int = 0) -> Decimal {
        var original: Decimal = self
        var rounded: Decimal = 0
        NSDecimalRound(&rounded, &original, scale, .plain)
        return rounded
    }
}
