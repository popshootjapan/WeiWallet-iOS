//
//  LatestTransactionListViewModel.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/04/14.
//  Copyright © 2018 popshoot All rights reserved.
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
        CacheProtocol,
        LocalTransactionRepositoryProtocol
    )
    
    private let walletManager: WalletManagerProtocol
    private let gethRepository: GethRepositoryProtocol
    private let updater: UpdaterProtocol
    private let cache: CacheProtocol
    private let localTransactionRepository: LocalTransactionRepositoryProtocol
    
    init(dependency: Dependency) {
        (walletManager, gethRepository, updater, cache, localTransactionRepository) = dependency
    }
    
    struct Input {
        let viewWillAppear: Driver<Void>
        let refreshControlDidRefresh: Driver<Void>
    }
    
    struct Output {
        let latestTransactionHistories: Driver<[TransactionHistory]>
        let isFetching: Driver<Bool>
        let error: Driver<Error>
    }
    
    func build(input: Input) -> Output {
        let geth = gethRepository
        let myAddress = walletManager.address()
        
        // Represents initial get transaction action. emits only when view will appear and updater.refreshTransactions.
        // the reason why initial and refresh actions are separated is to prevent a refresh control to be animated
        let getTransactionAction = Driver.merge(input.viewWillAppear, updater.refreshTransactions.asDriver(onErrorDriveWith: .empty()))
            .flatMap { _ -> Driver<Action<[Transaction]>> in
                let source = geth.getTransactions(address: myAddress).map { $0.elements }
                return Action.makeDriver(source)
            }
        
        let refreshControlDidRefresh = input.refreshControlDidRefresh
            // Refresh wallet balance when refershing transactions
            .do(onNext: { [weak self] in
                self?.updater.refreshBalance.onNext(())
                self?.updater.refreshRate.onNext(())
            })
        
        let refreshTransactionAction = refreshControlDidRefresh.flatMap { _ -> Driver<Action<[Transaction]>> in
            let source = geth.getTransactions(address: myAddress).map { $0.elements }
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
                let localObjects = weakSelf.localTransactionRepository.objects()
                    .sorted { $0.date > $1.date }
                
                return Driver.just(localObjects)
            }
            .do(onNext: { [weak self] localTransactions in
                // Delete local transactions which are older than 1 hour.
                localTransactions
                    .filter { Date(timeIntervalSince1970: TimeInterval($0.date)).timeIntervalSinceNow < Double(-3600.0) }
                    .forEach { [weak self] localTransaction in
                        self?.localTransactionRepository.delete(primaryKey: localTransaction.txID)
                }
            })
        
        let cachedTransactions = cache.load(type: [Transaction].self, for: .transactionHistory).asDriver(onErrorJustReturn: [])
        let latestTransactions = Driver.merge(getTransactionsAction.elements, cachedTransactions)
            .do(onNext: { [weak self] transactions in
                transactions.forEach {
                    // delete local transaction if the same txID is included in one of the transactions
                    self?.localTransactionRepository.delete(primaryKey: $0.hash)
                }
            })
            
        let latestHistoryKinds = latestTransactions
            .map { elements -> [TransactionHistoryKind] in
                return elements
                    // filters transactions executed more than a day ago,
                    // and shows only the first 5th.
                    .filter { $0.isExecutedLessThanDay }
                    .reversed()
                    .map { TransactionHistoryKind.remote($0) }
            }
        
        let localHistoryKinds = localTransactions
            .map { $0.map { TransactionHistoryKind.local($0) } }
        
        let transactionHistoryKinds = Driver.combineLatest(localHistoryKinds, latestHistoryKinds) { $0 + $1 }
        let latestTransactionHistories = transactionHistoryKinds.map { kinds -> [TransactionHistory] in
            return kinds
                // display only five elements
                .prefix(5)
                .map { TransactionHistory(kind: $0, myAddress: myAddress) }
        }
        
        return Output(
            latestTransactionHistories: latestTransactionHistories,
            isFetching: refreshTransactionAction.isExecuting,
            error: getTransactionsAction.error
        )
    }
}
