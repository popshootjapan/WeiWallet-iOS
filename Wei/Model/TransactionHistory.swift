//
//  TransactionHistory.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/21.
//  Copyright © 2018 popshoot All rights reserved.
//

import EthereumKit

enum TransactionHistoryKind {
    case local(LocalTransaction)
    case remote(Transaction)
}

struct TransactionHistory {
    let kind: TransactionHistoryKind
    let myAddress: String
}
