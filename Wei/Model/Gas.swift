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
    
    // NOTE: you can check safe low gas price at https://ethgasstation.info/
    // TODO: change to get estimate gas price from node or sever
    static let safeLow = Gas(
        gasLimit: 21000,
        gasPrice: Converter.toWei(GWei: 15)
    )
}
