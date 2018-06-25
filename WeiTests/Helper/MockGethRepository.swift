//
//  MockGethRepository.swift
//  WeiTests
//
//  Created by Ryo Fukuda on 2018/06/21.
//  Copyright © 2018 yz. All rights reserved.
//

import RxSwift
import RxCocoa
import EthereumKit
@testable import Wei

final class MockGethRepository: GethRepositoryProtocol {
    func getGasPrice() -> Single<Wei> {
        return Single.just(Wei(100))
    }
    
    func getBalance(address: String, blockParameter: BlockParameter) -> Single<Balance> {
        return Single.just(Balance(wei: Wei(100)))
    }
    
    func getTransactionCount(address: String, blockParameter: BlockParameter) -> Single<Int> {
        return Single.just(10)
    }
    
    func sendRawTransaction(rawTransaction: String) -> Single<SentTransaction> {
        return Single.just(SentTransaction(id: "id"))
    }
    
    func getTransactions(address: String) -> Single<Transactions> {
        return Single.just(Transactions(elements: []))
    }
}
