//
//  SelectAddressByQRViewModel.swift
//  Wei
//
//  Created by omatty198 on 2018/04/02.
//  Copyright © 2018年 yz. All rights reserved.
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
            .map { $0.stripeEthereumPrefix() }
            .throttle(1.0, latest: false)
            
        let pushSelectAmountViewController = address
            .filter { AddressValidator.validate($0) }
        
        let isAddressValid = address
            .filter { !AddressValidator.validate($0) }
            .map { _ in }
        
        return Output(
            isAddressValid: isAddressValid,
            pushSelectAmountViewController: pushSelectAmountViewController
        )
    }
}
