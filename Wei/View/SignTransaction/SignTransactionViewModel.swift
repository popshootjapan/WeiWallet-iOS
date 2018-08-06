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
    
    var rawTransaction: RawTransaction!
    
    typealias Dependency = (
        WalletManagerProtocol,
        CurrencyManagerProtocol,
        RateRepositoryProtocol
    )
    
    private let walletManager: WalletManagerProtocol
    private let currencyManager: CurrencyManagerProtocol
    private let rateRepository: RateRepositoryProtocol
    
    init(dependency: Dependency) {
        (walletManager, currencyManager, rateRepository) = dependency
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
    }
    
    func build(input: Input) -> Output {
        guard let rawTransaction = self.rawTransaction else {
            fatalError("RawTransaction is necessary")
        }
        
        let txFeeInWei = Wei(Gas.safeLow.gasLimit * Gas.safeLow.gasPrice)
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
        
        let isExecuting = Driver.merge(fiatAmountAction.isExecuting, fiatFeeAction.isExecuting, totalPriceAction.isExecuting)
            .distinctUntilChanged()
        
        let error = Driver.merge(fiatAmountAction.error, fiatFeeAction.error, totalPriceAction.error)
        
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
            error: error
        )
    }
}
