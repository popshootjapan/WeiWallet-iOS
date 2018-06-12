//
//  TransactionHistoryViewModel.swift
//  Wei
//
//  Created by omatty198 on 2018/04/12.
//  Copyright © 2018年 popshoot All rights reserved.
//

import RxSwift
import RxCocoa
import EthereumKit

final class TransactionHistoryViewModel: InjectableViewModel {
    
    typealias Dependency = (
        GethRepositoryProtocol,
        WalletManagerProtocol,
        CacheProtocol
    )
    
    private let gethRepository: GethRepositoryProtocol
    private let walletManager: WalletManagerProtocol
    private let cache: CacheProtocol
    
    init(dependency: Dependency) {
        (gethRepository, walletManager, cache) = dependency
    }
    
    struct Input {
        let viewWillAppear: Driver<Void>
        let refreshControlDidRefresh: Driver<Void>
    }
    
    struct Output {
        let transactionHistories: Driver<[TransactionHistory]>
        let isExecuting: Driver<Bool>
        let error: Driver<Error>
    }
    
    func build(input: Input) -> Output {
        let myAddress = walletManager.address()
        
        let initialGetTransactionsAction = input.viewWillAppear.flatMap { [weak self] _ -> Driver<Action<[Transaction]>> in
            guard let weakSelf = self else {
                return Driver.empty()
            }
            return weakSelf.getTransactionsAction()
        }
        
        let refreshGetTransactionsAction = input.refreshControlDidRefresh.flatMap { [weak self] _ -> Driver<Action<[Transaction]>> in
            guard let weakSelf = self else {
                return Driver.empty()
            }
            return weakSelf.getTransactionsAction()
        }
        
        let getTransactionsAction = Driver.merge(initialGetTransactionsAction, refreshGetTransactionsAction)
            .do(onNext: { [weak self] action in
                guard case .succeeded(let transactions) = action else {
                    return
                }
                self?.cache.save(transactions, for: .transactionHistory)
            })
        
        let cachedTransactions = cache.load(type: [Transaction].self, for: .transactionHistory).asDriver(onErrorJustReturn: [])
        
        let transactionHistories = Driver.merge(getTransactionsAction.elements, cachedTransactions)
            .map { $0.map { TransactionHistory(kind: TransactionHistoryKind.remote($0), myAddress: myAddress) } }
        
        return Output(
            transactionHistories: transactionHistories,
            isExecuting: refreshGetTransactionsAction.isExecuting,
            error: getTransactionsAction.error
        )
    }
    
    private func getTransactionsAction() -> Driver<Action<[Transaction]>> {
        let source = gethRepository.getTransactions(address: walletManager.address())
            .map { $0.elements.reversed().compactMap { $0 } }
        return Action.makeDriver(source)
    }
}

