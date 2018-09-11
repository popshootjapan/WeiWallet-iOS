//
//  SignTransactionViewModel.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/08/02.
//  Copyright © 2018 yz. All rights reserved.
//

import RxSwift
import RxCocoa
import EthereumKit

final class SignTransactionViewModel: InjectableViewModel {
    
    enum ActionKind {
        case sign
        case broadcast
    }
    
    var actionKind: ActionKind!
    var rawTransaction: RawTransaction!
    
    typealias Dependency = (
        ApplicationStoreProtocol,
        WalletManagerProtocol,
        CurrencyManagerProtocol,
        RateRepositoryProtocol,
        GethRepositoryProtocol
    )
    
    private let applicationStore: ApplicationStoreProtocol
    private let walletManager: WalletManagerProtocol
    private let currencyManager: CurrencyManagerProtocol
    private let rateRepository: RateRepositoryProtocol
    private let gethRepository: GethRepositoryProtocol
    
    init(dependency: Dependency) {
        (applicationStore, walletManager, currencyManager, rateRepository, gethRepository) = dependency
    }
    
    struct Input {
        let cancelButtonDidTap: Driver<Void>
        let doneButtonDidTap: Driver<Void>
    }
    
    struct Output {
        let dismissViewController: Driver<Void>
        let toAddress: Driver<String>
        let currency: Driver<Currency>
        let etherAmount: Driver<Ether>
        let fiatAmount: Driver<String>
        let etherFee: Driver<String>
        let fiatFee: Driver<String>
        let totalPrice: Driver<String>
        let isExecuting: Driver<Bool>
        let error: Driver<Error>
        let completed: Driver<String>
    }
    
    func build(input: Input) -> Output {
        guard let rawTransaction = self.rawTransaction, let actionKind = self.actionKind else {
            fatalError("RawTransaction is necessary")
        }
        
        let txFeeInWei = Wei(Gas.normalGasLimit * Converter.toWei(GWei: applicationStore.gasPrice))
        let currency = currencyManager.currency
        
        let etherAmount = Driver.just(try! Converter.toEther(wei: rawTransaction.value))
        let fiatAmountAction = currency.flatMap { [weak self] currency -> Driver<Action<Price>> in
            guard let weakSelf = self else {
                return Driver.empty()
            }
            let source = weakSelf.rateRepository.convertToFiat(from: rawTransaction.value.asString(withBase: 10), to: currency)
            return Action.makeDriver(source)
        }
        
        let etherFee = Driver.just(try! Converter.toEther(wei: txFeeInWei))
            .map { $0.string }
        
        let fiatFeeAction = Driver.combineLatest(Driver.just(txFeeInWei), currency).flatMap { [weak self] wei, currency -> Driver<Action<Price>> in
            guard let weakSelf = self else {
                return Driver.empty()
            }
            let source = weakSelf.rateRepository.convertToFiat(from: wei.asString(withBase: 10), to: currency)
            return Action.makeDriver(source)
        }
        
        let totalPriceAction = Driver.combineLatest(Driver.just(txFeeInWei + rawTransaction.value), currency)
            .flatMap { [weak self] wei, currency -> Driver<Action<Price>> in
                guard let weakSelf = self else {
                    return Driver.empty()
                }
                let source = weakSelf.rateRepository.convertToFiat(from: wei.asString(withBase: 10), to: currency)
                return Action.makeDriver(source)
            }
        
        let completeAction = input.doneButtonDidTap
            .flatMap { [weak self] _ -> Driver<String> in
                guard let weakSelf = self else {
                    return Driver.empty()
                }
                return Driver.just(try! weakSelf.walletManager.sign(rawTransaction: rawTransaction))
            }
            .flatMap { [weak self] signature -> Driver<Action<String>> in
                guard let weakSelf = self, actionKind == .broadcast else {
                    return Driver.just(Action.succeeded(signature))
                }
                
                let source = weakSelf.gethRepository.sendRawTransaction(rawTransaction: signature)
                    .map { $0.id }
                
                return Action.makeDriver(source)
            }
        
        let isExecuting = Driver.merge(
            fiatAmountAction.isExecuting,
            fiatFeeAction.isExecuting,
            totalPriceAction.isExecuting,
            completeAction.isExecuting
        )
        
        let error = Driver.merge(
            fiatAmountAction.error,
            fiatFeeAction.error,
            totalPriceAction.error,
            completeAction.error
        )
        
        return Output(
            dismissViewController: input.cancelButtonDidTap,
            toAddress: Driver.just(rawTransaction.to.string),
            currency: currency,
            etherAmount: etherAmount,
            fiatAmount: fiatAmountAction.elements.map { $0.price },
            etherFee: etherFee,
            fiatFee: fiatFeeAction.elements.map { $0.price },
            totalPrice: totalPriceAction.elements.map { $0.price },
            isExecuting: isExecuting,
            error: error,
            completed: completeAction.elements
        )
    }
}
