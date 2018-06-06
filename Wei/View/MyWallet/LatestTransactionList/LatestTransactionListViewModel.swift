//
//  LatestTransactionListViewModel.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/04/14.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation
import EthereumKit
import RxSwift
import RxCocoa

final class LatestTransactionListViewModel: InjectableViewModel {
    
    typealias Dependency = (
        WalletManagerProtocol,
        GethRepositoryProtocol,
        UpdaterProtocol,
        LocalTransactionRepositoryProtocol
    )
    
    private let walletManager: WalletManagerProtocol
    private let gethRepository: GethRepositoryProtocol
    private let updater: UpdaterProtocol
    private let localTransactionRepository: LocalTransactionRepositoryProtocol
    
    init(dependency: Dependency) {
        (walletManager, gethRepository, updater, localTransactionRepository) = dependency
    }
    
    struct Input {
        let viewWillAppear: Driver<Void>
        let refreshControlDidRefresh: Driver<Void>
    }
    
    struct Output {
        let latestTransactions: Driver<[TransactionHistory]>
        let isFetching: Driver<Bool>
        let error: Driver<Error>
    }
    
    func build(input: Input) -> Output {
        let geth = gethRepository
        let myAddress = walletManager.address()
        
        // Represents initial get transaction action. emits only when view will appear and updater.refreshTransactions.
        // the reason why initial and refresh actions are separated is to prevent a refresh control to be animated
        let getTransactionAction = Driver.merge(input.viewWillAppear, updater.refreshTransactions.asDriver(onErrorDriveWith: .empty()))
            .flatMap { _ -> Driver<Action<Transactions>> in
                let source = geth.getTransactions(address: myAddress)
                return Action.makeDriver(source)
            }
        
        let refreshControlDidRefresh = input.refreshControlDidRefresh
            // Refresh wallet balance when refershing transactions
            .do(onNext: { [weak self] in
                self?.updater.refreshBalance.onNext(())
                self?.updater.refreshRate.onNext(())
            })
        
        let refreshTransactionAction = refreshControlDidRefresh.flatMap { _ -> Driver<Action<Transactions>> in
            let source = geth.getTransactions(address: myAddress)
            return Action.makeDriver(source)
        }
        
        let getTransactionsAction = Driver.merge(getTransactionAction, refreshTransactionAction)
        
        // Local transactions saved in realm database, a local transaction will be deleted
        // when transactions get included into a block
        let updateTick = localTransactionRepository.updateTick.asDriver(onErrorDriveWith: .empty())
        let localTransactions = updateTick.startWith(())
            .flatMap { [weak self] _ -> Driver<[LocalTransaction]> in
                guard let weakSelf = self else {
                    return Driver.empty()
                }
                return Driver.just(weakSelf.localTransactionRepository.objects())
            }
            .do(onNext: { [weak self] localTransactions in
                localTransactions
                    .filter { Double($0.date) > Double(-3600.0) }
                    .forEach { [weak self] localTransaction in
                        self?.localTransactionRepository.delete(primaryKey: localTransaction.txID)
                    }
            })
        
        let (transactions, error) = (
            getTransactionsAction.elements.do(onNext: { [weak self] transactions in
                transactions.elements.forEach {
                    // delete local transaction if the same txID is included in one of the transactions
                    self?.localTransactionRepository.delete(primaryKey: $0.hash)
                }
            }),
            getTransactionsAction.error
        )
        
        // Create TransactionHistoryKind model from local transactions and remote transactions
        let transactionHistoryKinds = Driver
            .combineLatest(
                localTransactions
                    .map { $0
                        .map { TransactionHistoryKind.local($0) }
                    },
                transactions
                    .map { $0.elements
                        .filter { $0.isExecutedLessThanDay }
                        .reversed()
                    }
                    .map { $0
                        .map { TransactionHistoryKind.remote($0) }
                    }
            )
            .map { $0 + $1 }
        
        let latestTransactions = transactionHistoryKinds.map { kinds -> [TransactionHistory] in
            return kinds
                // display only five elements
                .prefix(5)
                .map { TransactionHistory(kind: $0, myAddress: myAddress) }
        }
        
        let isFetching = refreshTransactionAction.isExecuting
        
        return Output(
            latestTransactions: latestTransactions,
            isFetching: isFetching,
            error: error
        )
    }
}
