//
//  SendBaseViewModel.swift
//  Wei
//
//  Created by omatty198 on 2018/04/12.
//  Copyright © 2018年 popshoot All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SendBaseViewModel: ViewModel {
    
    struct Input {
        let cancelButtonDidTap: Driver<Void>
    }
    
    struct Output {
        let dismissViewController: Driver<Void>
    }
    
    func build(input: Input) -> Output {
        return Output(
            dismissViewController: input.cancelButtonDidTap
        )
    }
}

