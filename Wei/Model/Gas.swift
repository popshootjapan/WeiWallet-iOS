//
//  Gas.swift
//  Wei
//
//  Created by yuzushioh on 2018/05/13.
//  Copyright © 2018 yz. All rights reserved.
//

import EthereumKit

struct Gas {
    /// Limit of gas amount
    let gasLimit: Int
    
    /// Price of gas in wei unit.
    /// Be careful, it's WEI unit.
    let gasPrice: Int
    
    /// Normal value of gas is 21000 for gas limit and 41 gwei for gas price.
    static let normal = Gas(
        gasLimit: 21000,
        gasPrice: Converter.toWei(GWei: 41)
    )
    
    // NOTE: you can check safe low gas price at https://ethgasstation.info/
    // TODO: change to get estimate gas price from node or sever
    static let safeLow = Gas(
        gasLimit: 21000,
        gasPrice: Converter.toWei(GWei: 15)
    )
    
    /// Low value of gas is 21000 for gas limit and 1 GWei for gas price
    static let low = Gas(
        gasLimit: 21000,
        gasPrice: Converter.toWei(GWei: 1)
    )
}
