//
//  EthereumKit+Extension.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/04/14.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation
import EthereumKit

extension Converter {
    static func toYen(ether: Ether, rate: BDouble) -> BDouble {
        return rate * ether
    }
}

extension Balance {
    func yen(rate: BDouble) -> BDouble {
        return Converter.toYen(ether: ether, rate: rate)
    }
    
    func calculateFiatBalance(rate: Price) -> String {
        let fiatBalance = ether * BDouble(rate.price)!
        return fiatBalance.rounded().asString(withBase: 10)
    }
}

extension Ether {
    var string: String {
        // caluculating with decimalExpansion(precisionAfterComma: 6) returns incorrect value sometimes.
        // use 18 precision to caluculate and remove padding zeros after
        // we support the precision of 6 degits.
        let values = decimalExpansion(precisionAfterComma: 18).split(separator: ".")
        return stripePaddingZeros("\(values[0]).\(values[1].prefix(6))")
    }
    
    /// stripe padding zeros. if the last character is . after striping, remote . as well.
    /// caution: do not stripe all if the string is 0.
    private func stripePaddingZeros(_ string: String) -> String {
        let degits = string.split(separator: ".").first?.count ?? 1
        var string = string
        while (string.last == "0" || string.last == ".") && string.count > degits {
            string = String(string.dropLast())
        }
        return string
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
    static var currenct: Network {
        let network: Network
        #if DEBUG || INHOUSE
            network = .ropsten
        #else
            network = .main
        #endif
        return network
    }
}
