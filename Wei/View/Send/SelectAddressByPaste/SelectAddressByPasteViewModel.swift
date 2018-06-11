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
        let pushSelectAmountViewController: Driver<TransactionContext>
    }
    
    func build(input: Input) -> Output {
        let pasteByClipboardButtonDidTap = input.pasteByClipboardButtonDidTap
        
        let transactionContext = pasteByClipboardButtonDidTap
            .flatMap { Driver.from(optional: UIPasteboard.general.string) }
            .map { TransactionContext($0) }
        
        let pushSelectAmountViewController = transactionContext
            .filter { $0.isAddressValid }
        
        let isAddressValid = transactionContext
            .map { $0.isAddressValid }
        
        return Output(
            isAddressValid: isAddressValid,
            pushSelectAmountViewController: pushSelectAmountViewController
        )
    }
}
