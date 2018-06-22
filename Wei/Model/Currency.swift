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
    
    var balanceTitleName: String {
        switch self {
        case .jpy:
            return "日本円"
        case .usd:
            return "US Dollar"
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
