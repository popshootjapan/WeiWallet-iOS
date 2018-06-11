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
        WalletManagerProtocol
    )
    
    private let gethRepository: GethRepositoryProtocol
    private let walletManager: WalletManagerProtocol
    
    init(dependency: Dependency) {
        (gethRepository, walletManager) = dependency
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
        let refreshTrigger = Driver.merge(input.viewWillAppear, input.refreshControlDidRefresh)
        
        let getTransactionsAction = refreshTrigger.flatMap { [weak self] _ -> Driver<Action<[Transaction]>> in
            guard let weakSelf = self else {
                return Driver.empty()
            }
            
            let source = weakSelf.gethRepository.getTransactions(address: myAddress)
                .map { $0.elements.reversed().compactMap { $0 } }
            
            return Action.makeDriver(source)
        }
        
        let (transactionHistories, isExecuting, error) = (
            getTransactionsAction.elements
                .map { $0
                    .map {
                        TransactionHistory(
                            kind: TransactionHistoryKind.remote($0),
                            myAddress: myAddress
                        )
                    }
                },
            getTransactionsAction.isExecuting,
            getTransactionsAction.error
        )
        
        return Output(
            transactionHistories: transactionHistories,
            isExecuting: isExecuting,
            error: error
        )
    }
}

