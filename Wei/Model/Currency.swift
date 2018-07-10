//
//  Currency.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/12.
//  Copyright © 2018 popshoot All rights reserved.
//

import Foundation

enum Currency: String {
    case jpy = "JPY"
    case usd = "USD"
    
    static let all = [Currency.jpy, Currency.usd]
    
    var name: String {
        switch self {
        case .jpy:
            return R.string.localizable.commonJPY()
        case .usd:
            return R.string.localizable.commonUSD()
        }
    }
    
    var shortName: String {
        switch self {
        case .jpy:
            return R.string.localizable.commonJPYShort()
        case .usd:
            return R.string.localizable.commonUSDShort()
        }
    }
    
    var unit: String {
        switch self {
        case .jpy:
            return "￥"
        case .usd:
            return "$"
        }
    }
    
    var showBackupPopupAmount: Decimal {
        switch self {
        case .jpy:
            return 3000
        case .usd:
            return 30
        }
    }
}
