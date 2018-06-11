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
        GethRepositoryProtocol,
        WalletManagerProtocol,
        UpdaterProtocol,
        TransactionContext
    )
    
    private let gethRepository: GethRepositoryProtocol
    private let walletManager: WalletManagerProtocol
    private let updater: UpdaterProtocol
    private let transactionContext: TransactionContext
    
    init(dependency: Dependency) {
        (gethRepository, walletManager, updater, transactionContext) = dependency
    }
    
    struct Input {
        let confirmButtonDidTap: Driver<Void>
        let reselectAddressButtonDidTap: Driver<Void>
        let retryButtonDidTap: Driver<Void>
    }
    
    struct Output {
        let popToRootViewController: Driver<Void>
        let transactionContext: TransactionContext
        let sentTransaction: Driver<SentTransaction>
        let isFetching: Driver<Bool>
        let error: Driver<Error>
    }
    
    func build(input: Input) -> Output {
        let transactionContext = self.transactionContext
        
        let sendTransactionTrigger = Driver.merge(input.confirmButtonDidTap, input.retryButtonDidTap)
        let sendTransactionAction = sendTransactionTrigger.flatMapLatest { [weak self] _ -> Driver<Action<SentTransaction>> in
            guard let weakSelf = self else {
                return Driver.empty()
            }
            
            let address = weakSelf.walletManager.address()
            let nonce = weakSelf.gethRepository.getTransactionCount(address: address, blockParameter: .pending).asObservable()
            
            let signTransaction = nonce.flatMap { nonce -> Observable<String> in
                let wei = Converter.toWei(ether: transactionContext.etherAmount.ether()).asString(withBase: 10)
                let rawTransaction = RawTransaction(
                    wei: wei,
                    to: transactionContext.address,
                    gasPrice: Gas.safeLow.gasPrice,
                    gasLimit: Gas.safeLow.gasLimit,
                    nonce: nonce
                )
                return Observable.just(try weakSelf.walletManager.sign(rawTransaction: rawTransaction))
            }
            
            let sendTransaction = signTransaction.flatMap { [weak self] rawTransaction -> Observable<SentTransaction> in
                guard let weakSelf = self else {
                    return Observable.empty()
                }
                return weakSelf.gethRepository.sendRawTransaction(rawTransaction: rawTransaction).asObservable()
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
            popToRootViewController: input.reselectAddressButtonDidTap,
            transactionContext: transactionContext,
            sentTransaction: sentTransaction,
            isFetching: isFetching,
            error: error
        )
    }
}
