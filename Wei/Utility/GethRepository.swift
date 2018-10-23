//
//  GethRepository.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/03/16.
//  Copyright © 2018 popshoot All rights reserved.
//

import EthereumKit
import RxSwift
import RxCocoa

protocol GethRepositoryProtocol {
    func getGasPrice() -> Single<Wei>
    func getBalance(address: String, blockParameter: BlockParameter) -> Single<Balance>
    func getTransactionCount(address: String, blockParameter: BlockParameter) -> Single<Int>
    func sendRawTransaction(rawTransaction: String) -> Single<SentTransaction>
    func getTransactions(address: String) -> Single<Transactions>
}

final class GethRepository: GethRepositoryProtocol, Injectable {
    
    typealias Dependency = (
        ApplicationStoreProtocol
    )
    
    private let geth: Geth
    
    init(dependency: Dependency) {
        
        let nodeEndpoint: String
        switch dependency.network {
        case .mainnet, .ropsten, .kovan:
            nodeEndpoint = Environment.current.nodeEndpoint
        case .private(_, _):
            nodeEndpoint = dependency.privateNetworkEndpoint
                ?? Environment.current.nodeEndpoint
        }
        
        geth = Geth(configuration: Configuration(
            network: dependency.network,
            nodeEndpoint: nodeEndpoint,
            etherscanAPIKey: Environment.current.etherscanAPIKey,
            debugPrints: Environment.current.debugPrints
        ))
    }
    
    func getGasPrice() -> Single<Wei> {
        return Single.create { [weak geth] observer in
            geth?.getGasPrice() { result in
                switch result {
                case .success(let gasPrice):
                    observer(.success(gasPrice))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func getBalance(address: String, blockParameter: BlockParameter) -> Single<Balance> {
        return Single.create { [weak geth] observer in
            geth?.getBalance(of: address, blockParameter: blockParameter) { result in
                switch result {
                case .success(let balance):
                    observer(.success(balance))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func getTransactionCount(address: String, blockParameter: BlockParameter) -> Single<Int> {
        return Single.create { [weak geth] observer in
            geth?.getTransactionCount(of: address, blockParameter: blockParameter) { result in
                switch result {
                case .success(let count):
                    observer(.success(count))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func sendRawTransaction(rawTransaction: String) -> Single<SentTransaction> {
        return Single.create { [weak geth] observer in
            geth?.sendRawTransaction(rawTransaction: rawTransaction) { result in
                switch result {
                case .success(let sentTransaction):
                    observer(.success(sentTransaction))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func getTransactions(address: String) -> Single<Transactions> {
        return Single.create { [weak geth] observer in
            geth?.getTransactions(address: address) { result in
                switch result {
                case .success(let transactions):
                    observer(.success(transactions))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}
