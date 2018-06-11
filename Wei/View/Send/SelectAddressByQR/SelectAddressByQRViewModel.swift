//
//  SelectAddressByQRViewModel.swift
//  Wei
//
//  Created by omatty198 on 2018/04/02.
//  Copyright © 2018年 popshoot All rights reserved.
//

import RxSwift
import RxCocoa

final class SelectAddressByQRViewModel: ViewModel {
    
    struct Input {
        let address: Driver<String>
    }
    
    struct Output {
        let isAddressValid: Driver<Void>
        let pushSelectAmountViewController: Driver<TransactionContext>
    }
    
    func build(input: Input) -> Output {
        let transactionContext = input.address
            .map { TransactionContext($0.stripeEthereumPrefix()) }
            .throttle(1.0, latest: false)
            
        let pushSelectAmountViewController = transactionContext
            .filter { $0.isAddressValid }
        
        let isAddressValid = transactionContext
            .filter { !$0.isAddressValid }
            .map { _ in }
        
        return Output(
            isAddressValid: isAddressValid,
            pushSelectAmountViewController: pushSelectAmountViewController
        )
    }
}
