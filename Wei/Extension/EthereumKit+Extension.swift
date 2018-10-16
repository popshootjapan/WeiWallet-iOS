//
//  EthereumKit+Extension.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/04/14.
//  Copyright © 2018 popshoot All rights reserved.
//

import Foundation
import EthereumKit

extension Balance {
    var ether: Ether {
        return (try? ether()) ?? Decimal(0)
    }
    
    /// Calculate fiat balance by the provided rate.
    /// if fiatRate parameter is a JPY, it returns fiat balance in JPY
    /// if USD, then it returns one in USD
    func calculateFiatBalance(fiatRate: Fiat) -> Fiat {
        let fiatBalance = (ether * fiatRate.value).round(scale: 2)
        switch fiatRate {
        case .jpy:
            return Fiat.jpy(fiatBalance.toInt64())
        case .usd:
            return Fiat.usd(fiatBalance)
        }
    }
}

extension Ether {
    var string: String {
        return round(scale: 6).description
    }
}

extension Transaction {
    var isPending: Bool {
        return (Int64(confirmations) ?? 0) < 1
    }
    
    var isExecutedLessThanDay: Bool {
        guard let unixTime = TimeInterval(timeStamp) else {
            return false
        }
        
        let date = Date(timeIntervalSince1970: unixTime)
        return date.timeIntervalSinceNow > (Double(-3600.0) * Double(24.0))
    }
    
    func isReceiveTransaction(myAddress: String) -> Bool {
        // NOTE: Addresses returned from Etherscan is lowercased.
        // To check correctlly, you need to lowercase the address.
        return to == myAddress.lowercased()
    }
}

extension Network {
    static var current: Network {
        let network: Network
        #if DEBUG || INHOUSE
            network = .ropsten
        #else
            network = .mainnet
        #endif
        return network
    }
    
    static let all: [Network] = [.mainnet, .ropsten, .kovan]
}
