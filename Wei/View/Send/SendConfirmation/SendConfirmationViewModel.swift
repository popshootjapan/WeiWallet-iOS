//
//  SendConfirmationViewModel.swift
//  Wei
//
//  Created by omatty198 on 2018/04/02.
//  Copyright © 2018年 popshoot All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import EthereumKit

final class SendConfirmationViewModel: InjectableViewModel {
    
    typealias Dependency = (
        ApplicationStoreProtocol,
        GethRepositoryProtocol,
        WalletManagerProtocol,
        UpdaterProtocol,
        LocalTransactionRepositoryProtocol,
        CurrencyManagerProtocol,
        TransactionContext
    )
    
    private let applicationStore: ApplicationStoreProtocol
    private let gethRepository: GethRepositoryProtocol
    private let walletManager: WalletManagerProtocol
    private let updater: UpdaterProtocol
    private let localTransactionRepository: LocalTransactionRepositoryProtocol
    private let currencyManager: CurrencyManagerProtocol
    private let transactionContext: TransactionContext
    
    init(dependency: Dependency) {
        (applicationStore, gethRepository, walletManager, updater, localTransactionRepository, currencyManager, transactionContext) = dependency
    }
    
    struct Input {
        let confirmButtonDidTap: Driver<Void>
        let reselectAddressButtonDidTap: Driver<Void>
        let retryButtonDidTap: Driver<Void>
    }
    
    struct Output {
        let transactionContext: Driver<TransactionContext>
        let currency: Driver<Currency>
        let sentTransaction: Driver<SentTransaction>
        let isFetching: Driver<Bool>
        let error: Driver<Error>
        let popToRootViewController: Driver<Void>
    }
    
    func build(input: Input) -> Output {
        let transactionContext = self.transactionContext
        
        let sendTransactionTrigger = Driver.merge(input.confirmButtonDidTap, input.retryButtonDidTap)
        let sendTransactionAction = sendTransactionTrigger.flatMapLatest { [weak self] _ -> Driver<Action<SentTransaction>> in
            guard let weakSelf = self else {
                return Driver.empty()
            }
            
            let gas = Gas(gasLimit: Gas.normalGasLimit, gasPrice: Converter.toWei(GWei: weakSelf.applicationStore.gasPrice))
            let address = weakSelf.walletManager.address()
            
            let value: String
            do {
                value = try Converter.toWei(ether: transactionContext.etherAmount.ether()).asString(withBase: 10)
            } catch let error {
                return Driver.just(Action.failed(error))
            }
            
            let nonce = weakSelf.gethRepository.getTransactionCount(address: address, blockParameter: .pending).asObservable()
                // NonceManager.manage manages the nonce value because sending ether constantly cases
                // the not-increment nonce value problem.
                .map(NonceManager.manage)
            
            let signTransaction = nonce.flatMap { [weak self] nonce -> Observable<String> in
                guard let weakSelf = self else {
                    return Observable.empty()
                }
                let rawTransaction = RawTransaction(wei: value, to: transactionContext.address, gasPrice: gas.gasPrice, gasLimit: gas.gasLimit, nonce: nonce)
                return Observable.just(try weakSelf.walletManager.sign(rawTransaction: rawTransaction))
            }
            
            let sendTransaction = signTransaction.flatMap { [weak self] rawTransaction -> Observable<SentTransaction> in
                guard let weakSelf = self else {
                    return Observable.empty()
                }
                
                return weakSelf.gethRepository.sendRawTransaction(rawTransaction: rawTransaction).asObservable()
                    .do(onNext: { [weak self] sentTransaction in
                        // Save sent transaction data temporary in realm data base.
                        let localTransaction = LocalTransaction()
                        localTransaction.txID = sentTransaction.id
                        localTransaction.from = address
                        localTransaction.to = transactionContext.address
                        localTransaction.value = value
                        localTransaction.gasLimit = gas.gasLimit
                        localTransaction.gasPrice = gas.gasPrice
                        localTransaction.date = Int64(Date().timeIntervalSince1970)
                        self?.localTransactionRepository.add(localTransaction)
                    })
            }
            
            return Action.makeDriver(sendTransaction)
        }
        
        let (sentTransaction, isFetching, error) = (
            sendTransactionAction.elements.do(onNext: { [weak self] _ in
                self?.updater.refreshBalance.onNext(())
                self?.updater.refreshTransactions.onNext(())
            }),
            sendTransactionAction.isExecuting,
            sendTransactionAction.error
        )

        return Output(
            transactionContext: Driver.just(transactionContext),
            currency: currencyManager.currency.asDriver(onErrorDriveWith: .empty()),
            sentTransaction: sentTransaction,
            isFetching: isFetching,
            error: error,
            popToRootViewController: input.reselectAddressButtonDidTap
        )
    }
}
