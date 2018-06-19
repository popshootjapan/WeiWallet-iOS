//
//  SelectAddressByPasteViewModel.swift
//  Wei
//
//  Created by omatty198 on 2018/04/02.
//  Copyright © 2018年 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectAddressByPasteViewModel: ViewModel {
    
    struct Input {
        let pasteByClipboardButtonDidTap: Driver<Void>
    }
    
    struct Output {
        let isAddressValid: Driver<Bool>
        let pushSelectAmountViewController: Driver<String>
    }
    
    func build(input: Input) -> Output {
        let pasteByClipboardButtonDidTap = input.pasteByClipboardButtonDidTap
        
        let address = pasteByClipboardButtonDidTap
            .flatMap { Driver.from(optional: UIPasteboard.general.string) }
        
        let pushSelectAmountViewController = address
            .filter { AddressValidator(address: $0).validate() }
        
        let isAddressValid = address
            .map { AddressValidator(address: $0).validate() }
        
        return Output(
            isAddressValid: isAddressValid,
            pushSelectAmountViewController: pushSelectAmountViewController
        )
    }
}
