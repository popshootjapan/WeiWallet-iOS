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
    
    var toAddress: String!
    
    typealias Dependency = (
        BalanceStoreProtocol,
        RateRepositoryProtocol,
        CurrencyManagerProtocol
    )
    
    private let balanceStore: BalanceStoreProtocol
    private let rateRepository: RateRepositoryProtocol
    private let currencyManager: CurrencyManagerProtocol

    init(dependency: Dependency) {
        (balanceStore, rateRepository, currencyManager) = dependency
    }
    
    struct Input {
        let viewWillAppear: Driver<Void>
        let confirmButtonDidTap: Driver<Void>
        let amountTextFieldDidInput: Driver<String>
    }
    
    struct Output {
        let showSendConfirmationViewController: Driver<TransactionContext>
        let fiatBalance: Driver<Fiat>
        let availableFiatBalance: Driver<Fiat>
        let inputFiatAmount: Driver<Fiat>
        let etherAmount: Driver<Ether>
        let txFee: Driver<Fiat>
        let error: Driver<Error>
    }
    
    func build(input: Input) -> Output {
        let address = self.toAddress!
        let currency = currencyManager.currency.asDriver(onErrorDriveWith: .empty())
        
        // NOTE: Deal with fixed tx fee
        let txFee = Wei(Gas.safeLow.gasLimit * Gas.safeLow.gasPrice)
        
        // fiatTxFeeAction converts specified tx fee to fiat price.
        let fiatTxFeeAction = input.viewWillAppear
            .withLatestFrom(currency)
            .flatMap { [weak self] currency -> Driver<Action<(Price, Currency)>> in
                guard let weakSelf = self else {
                    return Driver.just(Action.succeeded((Price(price: "0", currency: nil), currency)))
                }
                
                let source = weakSelf.rateRepository.convertToFiat(from: txFee.description, to: currency)
                    .map { ($0, currency) }
                
                return Action.makeDriver(source)
            }
        
        // fiatTxFee returns current fiat value in Fiat structure.
        let fiatTxFee = fiatTxFeeAction.elements.flatMap { price, currency -> Driver<Fiat> in
            guard let doubleValue = Double(price.price) else {
                return .empty()
            }
            
            switch currency {
            case .jpy:
                // stripe the decimal amount from tx fee.
                // only use number before the decimal poin.
                // for example 2 for 1.2345
                return Driver.just(Fiat.jpy(Int64(ceil(doubleValue))))
            
            case .usd:
                return Driver.just(Fiat.usd(Decimal(doubleValue)))
            }
        }
        
        // User's total fiat balance
        let fiatBalance = balanceStore.fiatBalance.asDriver(onErrorDriveWith: .empty())
        
        // User's usable fiat balance (totalBalance - txFee)
        let availableBalance = Driver.combineLatest(fiatBalance, fiatTxFee) { balance, txFee -> Fiat in
            let availableBalance = balance.value - txFee.value
            // do not return negative value here.
            assert(availableBalance >= 0)
            switch balance {
            case .jpy:
                return Fiat.jpy(availableBalance.toInt64())
            case .usd:
                return Fiat.usd(availableBalance)
            }
        }
        
        // fiatAmount represents an amount user gives as an input in text field.
        // if user's input is larger than user's fiat balance, it returns user's total balance.
        let inputFiatAmount = Driver
            .combineLatest(input.amountTextFieldDidInput, availableBalance)
            .map { inputAmount, balance -> Fiat in
                let decimal = Decimal(string: inputAmount) ?? 0
                let amount = decimal <= balance.value ? decimal : balance.value
                
                switch balance {
                case .jpy:
                    return Fiat.jpy(amount.toInt64())
                
                case .usd:
                    return Fiat.usd(amount)
                }
            }
        
        // in convertToEtherAction fiatAmount is converted to ether unit
        // if fiatAmount is empty, or 0, it will return the price of 0.
        let convertToEtherAction = inputFiatAmount
            .withLatestFrom(currency) { ($0, $1) }
            .flatMapLatest { [weak self] fiatAmount, currency -> Driver<Action<Price>> in
                guard let weakSelf = self, fiatAmount.value > 0 else {
                    // NOTE: Returns price of 0 if the fiatAmount is empty and/or fiatAmount is 0
                    return Driver.just(Action.succeeded(Price(price: "0", currency: nil)))
                }
                
                let source = weakSelf.rateRepository.convertToEther(from: fiatAmount.value.description, to: currency)
                return Action.makeDriver(source)
        }
        
        let etherAmount = convertToEtherAction.elements
            .flatMap { price -> Driver<Ether> in
                guard let ether = Ether(string: price.price) else {
                    return Driver.empty()
                }
                return Driver.just(ether)
            }
        
        let transactionContext = Driver.combineLatest(etherAmount, inputFiatAmount, fiatTxFee) {
            return TransactionContext(address: address, etherAmount: Amount.ether($0), fiatAmount: Amount.fiat($1), fiatFee: Amount.fiat($2))
        }
        
        let showSendConfirmationWithTransactionContext = input.confirmButtonDidTap
            .withLatestFrom(transactionContext)
        
        let errors = Driver.merge(
            convertToEtherAction.error,
            fiatTxFeeAction.error
        )
        
        return Output(
            showSendConfirmationViewController: showSendConfirmationWithTransactionContext,
            fiatBalance: fiatBalance,
            availableFiatBalance: availableBalance,
            inputFiatAmount: inputFiatAmount,
            etherAmount: etherAmount,
            txFee: fiatTxFee,
            error: errors
        )
    }
}
