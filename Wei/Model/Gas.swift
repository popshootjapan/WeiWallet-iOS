//
//  Gas.swift
//  Wei
//
//  Created by yuzushioh on 2018/05/13.
//  Copyright © 2018 popshoot All rights reserved.
//

import EthereumKit

struct Gas {
    /// Limit of gas amount
    let gasLimit: Int
    
    /// Price of gas in wei unit.
    /// Be careful, it's WEI unit.
    let gasPrice: Int
    
    static let normalGasPriceInGWei = 41
    static let normalGasLimit = 21000
}
