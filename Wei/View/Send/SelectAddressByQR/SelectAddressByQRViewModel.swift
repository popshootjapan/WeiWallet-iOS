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
        let pushSelectAmountViewController: Driver<String>
    }
    
    func build(input: Input) -> Output {
        let address = input.address
            .map { $0.stripEthereumPrefix() }
            .throttle(1.0, latest: false)
            
        let pushSelectAmountViewController = address
            .filter { AddressValidator(address: $0).validate() }
        
        let isAddressValid = address
            .filter { !AddressValidator(address: $0).validate() }
            .map { _ in }
        
        return Output(
            isAddressValid: isAddressValid,
            pushSelectAmountViewController: pushSelectAmountViewController
        )
    }
}
