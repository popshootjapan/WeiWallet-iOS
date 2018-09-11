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
        ApplicationStoreProtocol,
        BalanceStoreProtocol,
        RateRepositoryProtocol,
        CurrencyManagerProtocol
    )
    
    private let applicationStore: ApplicationStoreProtocol
    private let balanceStore: BalanceStoreProtocol
    private let rateRepository: RateRepositoryProtocol
    private let currencyManager: CurrencyManagerProtocol

    init(dependency: Dependency) {
        (applicationStore, balanceStore, rateRepository, currencyManager) = dependency
    }
    
    struct Input {
        let viewWillAppear: Driver<Void>
        let confirmButtonDidTap: Driver<Void>
        let amountTextFieldDidInput: Driver<String>
    }
    
    struct Output {
        let showSendConfirmationViewController: Driver<TransactionContext>
        let currency: Driver<Currency>
        let fiatBalance: Driver<Fiat>
        let availableFiatBalance: Driver<Fiat>
        let inputAmount: Driver<String>
        let etherAmount: Driver<Ether>
        let txFee: Driver<Fiat>
        let error: Driver<Error>
    }
    
    func build(input: Input) -> Output {
        let address = self.toAddress!
        let currency = currencyManager.currency
        
        // NOTE: Deal with fixed tx fee
        let txFee = Wei(Gas.normalGasLimit * Converter.toWei(GWei: applicationStore.gasPrice))
        
        // fiatTxFeeAction converts specified tx fee to fiat price.
        let fiatTxFeeAction = Driver.combineLatest(input.viewWillAppear, currency)
            .flatMap { [weak self] _, currency -> Driver<Action<(Price, Currency)>> in
                guard let weakSelf = self else {
                    return Driver.just(Action.succeeded((Price(price: "0", currency: nil), currency)))
                }
                
                let source = weakSelf.rateRepository.convertToFiat(from: txFee.description, to: currency)
                    .map { ($0, currency) }
                
                return Action.makeDriver(source)
            }
        
        // fiatTxFee returns current fiat value in Fiat structure.
        let fiatTxFee = fiatTxFeeAction.elements
            .flatMap { price, currency -> Driver<Fiat> in
                guard let doubleValue = Double(price.price) else {
                    return .empty()
                }
                
                switch currency {
                case .jpy:
                    // strip the decimal amount from tx fee.
                    // only use number before the decimal point.
                    // for example 2 for 1.2345
                    return Driver.just(Fiat.jpy(Int64(ceil(doubleValue))))
                
                case .usd:
                    return Driver.just(Fiat.usd(Decimal(doubleValue)))
                }
            }
            .distinctUntilChanged()
        
        // User's total fiat balance
        let fiatBalance = balanceStore.fiatBalance.asDriver(onErrorDriveWith: .empty())
        
        // User's usable fiat balance (totalBalance - txFee)
        let availableBalance = Driver
            .combineLatest(fiatBalance, fiatTxFee) { balance, txFee -> Fiat in
                let availableBalance = balance.value - txFee.value
                
                // if availableBalance is a negative value, it returns 0
                switch balance {
                case .jpy:
                    return Fiat.jpy(availableBalance >= 0 ? availableBalance.toInt64() : 0)
                case .usd:
                    return Fiat.usd(availableBalance >= 0 ? availableBalance : 0)
                }
            }
        
        // inputAmount will be used to manage input text field text. it will prevents the text field from having
        // invalid string value(which cannot be converted to Decimal).
        let inputAmount = Driver
            .combineLatest(input.amountTextFieldDidInput, availableBalance)
            .map { inputAmount, availableBalance -> String in
                guard availableBalance.value > 0 else {
                    return "0"
                }
                
                // Returns 0 if input amount contains only zero.
                guard inputAmount.map({ $0 == "0"}).contains(false) else {
                    return "0"
                }
                
                // If input text has more than one ".", then return the string with last letter dropped.
                // eg, 12.9. -> 12.9
                guard inputAmount.filter({ $0 == "." }).count <= 1 else {
                    return String(inputAmount.dropLast())
                }
                
                // If input text has more than 2 decimal points, return the string with last letter dropped
                // eg, 1.324 -> 1.32
                let subStrings = inputAmount.split(separator: ".")
                if let subString = subStrings.last, subStrings.count == 2 && String(subString).count > 2 {
                    return String(inputAmount.dropLast())
                }
                
                // If input cannot be converted to Decimal type, then return the string with last letter dropped
                // eg, 1.32a -> 1.32
                guard let amount = Decimal(string: inputAmount)?.round(scale: 2) else {
                    return String(inputAmount.dropLast())
                }
                
                let availableAmount = availableBalance.value.round(scale: 2)
                
                return amount <= availableAmount ?
                    amount.description : availableAmount.description
            }
        
        // fiatAmount represents an amount user gives as an input in text field.
        // if user's input is larger than user's fiat balance, it returns user's total balance.
        let inputFiatAmount = Driver
            .combineLatest(inputAmount, currency)
            .map { amountText, currency -> Fiat in
                let amount = Decimal(string: amountText) ?? 0
                switch currency {
                case .jpy:
                    return Fiat.jpy(amount.toInt64())
                case .usd:
                    return Fiat.usd(amount)
                }
            }
        
        // in convertToEtherAction fiatAmount is converted to ether unit
        // if fiatAmount is empty, or 0, it will return the price of 0.
        let convertToEtherAction = Driver.combineLatest(inputFiatAmount, currency)
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
            .distinctUntilChanged()
        
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
            currency: currency,
            fiatBalance: fiatBalance,
            availableFiatBalance: availableBalance,
            inputAmount: inputAmount,
            etherAmount: etherAmount,
            txFee: fiatTxFee,
            error: errors
        )
    }
}
