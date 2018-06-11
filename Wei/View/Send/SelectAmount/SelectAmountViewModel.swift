//
//  SelectAmountViewModel.swift
//  Wei
//
//  Created by omatty198 on 2018/04/02.
//  Copyright © 2018年 popshoot All rights reserved.
//

import Foundation
import EthereumKit
import RxSwift
import RxCocoa

final class SelectAmountViewModel: InjectableViewModel {
    
    typealias Dependency = (
        BalanceStoreProtocol,
        RateRepositoryProtocol,
        TransactionContext
    )
    
    private let balanceStore: BalanceStoreProtocol
    private let rateRepository: RateRepositoryProtocol
    private let transactionContext: TransactionContext

    init(dependency: Dependency) {
        (balanceStore, rateRepository, transactionContext) = dependency
    }
    
    struct Input {
        let viewWillAppear: Driver<Void>
        let confirmButtonDidTap: Driver<Void>
        let amountTextFieldDidInput: Driver<String>
    }
    
    struct Output {
        let showSendConfirmationViewController: Driver<TransactionContext>
        let fiatBalance: Driver<Int64>
        let fiatAmount: Driver<Int64>
        let etherAmount: Driver<String>
        let txFee: Driver<Int64>
        let error: Driver<Error>
    }
    
    func build(input: Input) -> Output {
        let transactionContext = self.transactionContext
        
        // NOTE: Deal with fixed tx fee
        let txFee = Wei(Gas.safeLow.gasLimit * Gas.safeLow.gasPrice)
        
        // fiatTxFeeAction converts specified tx fee to fiat price.
        let fiatTxFeeAction = input.viewWillAppear.flatMap { [weak self] _ -> Driver<Action<Price>> in
            guard let weakSelf = self else {
                return Driver.just(Action.succeeded(Price(price: "0", currency: nil)))
            }
            let source = weakSelf.rateRepository.convertToFiat(from: txFee.description).asObservable()
            return Action.makeDriver(source)
        }
        
        // stripe the decimal amount from tx fee.
        // only use number before the decimal poin.
        // for example 2 for 1.2345
        let fiatTxFee = fiatTxFeeAction.elements.flatMap { price -> Driver<Int64> in
            guard let doubleValue = Double(price.price) else {
                return .empty()
            }
            return Driver.just(Int64(ceil(doubleValue)))
        }
        
        // User's total fiat balance
        let fiatBalance = balanceStore.fiatBalance.asDriver(onErrorDriveWith: .empty()).flatMap { balanceString -> Driver<Int64> in
            return Driver.just(Int64(balanceString) ?? 0)
        }
        
        // User's usable fiat balance (totalBalance - txFee)
        let availableBalance = Driver.combineLatest(fiatBalance, fiatTxFee) { balance, txFee -> Int64 in
            let availableBalance = balance - txFee
            // do not return negative value here.
            return availableBalance > 0 ? availableBalance : 0
        }
        
        // fiatAmount represents an amount user gives as an input in text field.
        // if user's input is larger than user's fiat balance, it returns user's total balance.
        let inputFiatAmount = Driver
            .combineLatest(input.amountTextFieldDidInput, availableBalance)
            .map { inputAmount, balance -> Int64 in
                guard let amount = Int64(inputAmount) else {
                    return 0
                }
                return amount <= balance ? amount : balance
            }
        
        // in convertToEtherAction fiatAmount is converted to ether unit
        // if fiatAmount is empty, or 0, it will return the price of 0.
        let convertToEtherAction = inputFiatAmount.flatMapLatest { [weak self] fiatAmount -> Driver<Action<Price>> in
            guard let weakSelf = self, fiatAmount > 0 else {
                // NOTE: Returns price of 0 if the fiatAmount is empty and/or fiatAmount is 0
                return Driver.just(Action.succeeded(Price(price: "0", currency: nil)))
            }
            
            let source = weakSelf.rateRepository.convertToEther(from: String(fiatAmount))
            return Action.makeDriver(source)
        }
        
        let etherAmount = convertToEtherAction.elements
            .map { $0.price }
        
        let showSendConfirmationWithTransactionContext = input.confirmButtonDidTap
            .withLatestFrom(Driver.combineLatest(inputFiatAmount, etherAmount, fiatTxFee))
            .map { TransactionContext(
                transactionContext.address,
                fiatAmount: .fiat($0),
                etherAmount: .ether(Ether($1)!),
                fiatFee: .fiat($2),
                etherFee: .ether(Converter.toEther(wei: txFee))
            )}
        
        let errors = Driver.merge(
            convertToEtherAction.error,
            fiatTxFeeAction.error
        )
        
        return Output(
            showSendConfirmationViewController: showSendConfirmationWithTransactionContext,
            fiatBalance: fiatBalance,
            fiatAmount: inputFiatAmount,
            etherAmount: etherAmount,
            txFee: fiatTxFee,
            error: errors
        )
    }
}
