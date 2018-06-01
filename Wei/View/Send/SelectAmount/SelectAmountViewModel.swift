//
//  SelectAmountViewModel.swift
//  Wei
//
//  Created by omatty198 on 2018/04/02.
//  Copyright © 2018年 yz. All rights reserved.
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
        let fiatBalance: Driver<String>
        let fiatAmount: Driver<String>
        let etherAmount: Driver<String>
        let txFee: Driver<String>
        let error: Driver<Error>
    }
    
    func build(input: Input) -> Output {
        let transactionContext = self.transactionContext
        
        // NOTE: Deal with fixed tx fee
        let txFee = Wei(Gas.safeLow.gasLimit * Gas.safeLow.gasPrice)
        
        // User's total fiat balance
        let fiatBalance = balanceStore.fiatBalance.asDriver(onErrorDriveWith: .empty())
        
        // fiatAmount represents an amount user gives as an input in text field.
        // if user's input is larger than user's fiat balance, it returns user's total balance.
        let fiatAmount = Driver
            .combineLatest(input.amountTextFieldDidInput, fiatBalance)
            .map { inputAmount, currentBalance -> String in
                guard let amount = Int64(inputAmount), let balance = Int64(currentBalance) else {
                    return "0"
                }
                return amount <= balance ? String(amount) : String(balance)
            }
        
        // in convertToEtherAction fiatAmount is converted to ether unit
        // if fiatAmount is empty, or 0, it will return the price of 0.
        let convertToEtherAction = fiatAmount.flatMapLatest { [weak self] fiatAmount -> Driver<Action<Price>> in
            guard let weakSelf = self, !fiatAmount.isEmpty, fiatAmount != "0" else {
                // NOTE: Returns price of 0 if the fiatAmount is empty and/or fiatAmount is 0
                return Driver.just(Action.succeeded(Price(price: "0", currency: nil)))
            }
            
            let source = weakSelf.rateRepository.convertToEther(from: fiatAmount)
            return Action.makeDriver(source)
        }
        
        // fiatTxFeeAction converts specified tx fee to fiat price.
        let fiatTxFeeAction = input.viewWillAppear.flatMap { [weak self] _ -> Driver<Action<Price>> in
            guard let weakSelf = self else {
                return Driver.just(Action.succeeded(Price(price: "0", currency: nil)))
            }
            let source = weakSelf.rateRepository.convertToFiat(from: txFee.description).asObservable()
            return Action.makeDriver(source)
        }
        
        let etherAmount = convertToEtherAction.elements
            .map { $0.price }
        
        let fiatTxFee = fiatTxFeeAction.elements
            // only use number before the decimal poin.
            // for exsample 1 for 1.2345
            .map { String($0.price.split(separator: ".").first ?? "") }
        
        let showSendConfirmationWithTransactionContext = input.confirmButtonDidTap
            .withLatestFrom(Driver.combineLatest(fiatAmount, etherAmount, fiatTxFee))
            .map { TransactionContext(
                transactionContext.address,
                fiatAmount: .fiat(Int64($0)!),
                etherAmount: .ether(Ether($1)!),
                fiatFee: .fiat(Int64($2)!),
                etherFee: .ether(Converter.toEther(wei: txFee))
            )}
        
        let errors = Driver.merge(
            convertToEtherAction.error,
            fiatTxFeeAction.error
        )
        
        return Output(
            showSendConfirmationViewController: showSendConfirmationWithTransactionContext,
            fiatBalance: fiatBalance,
            fiatAmount: fiatAmount,
            etherAmount: etherAmount,
            txFee: fiatTxFee,
            error: errors
        )
    }
}
