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
        CurrencyManagerProtocol
    )
    
    private let walletManager: WalletManagerProtocol
    private let currencyManager: CurrencyManagerProtocol
    
    init(dependency: Dependency) {
        (walletManager, currencyManager) = dependency
    }
    
    struct Input {
        let cancelButtonDidTap: Driver<Void>
        let doneButtonDidTap: Driver<Void>
    }
    
    struct Output {
        let dismissViewController: Driver<Void>
        let currency: Driver<Currency>
        let etherAmount: Driver<Ether>
    }
    
    func build(input: Input) -> Output {
        guard let rawTransaction = self.rawTransaction else {
            fatalError("RawTransaction is necessary")
        }
        
        let etherAmount = Driver.just(try! Converter.toEther(wei: rawTransaction.value))
        
        return Output(
            dismissViewController: input.cancelButtonDidTap,
            currency: currencyManager.currency,
            etherAmount: etherAmount
        )
    }
}
