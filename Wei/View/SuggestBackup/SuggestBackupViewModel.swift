//
//  SuggestBackupViewModel.swift
//  Wei
//
//  Created by omatty198 on 2018/05/14.
//  Copyright © 2018年 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SuggestBackupViewModel: ViewModel {
    
    struct Input {
        let backupButtonDidTap: Driver<Void>
        let closeButtonDidTap: Driver<Void>
    }
    
    struct Output {
        let presentBackupViewController: Driver<Void>
        let dismissViewController: Driver<Void>
    }
    
    func build(input: Input) -> Output {
        return Output(
            presentBackupViewController: input.backupButtonDidTap,
            dismissViewController: input.closeButtonDidTap
        )
    }
}

