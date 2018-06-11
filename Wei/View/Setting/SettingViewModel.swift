//
//  SettingViewModel.swift
//  Wei
//
//  Created by omatty198 on 2018/04/12.
//  Copyright © 2018年 popshoot All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingViewModel: ViewModel {
    
    struct Input {
        let itemSelected: Driver<IndexPath>
    }
    
    struct Output {
        let presentSomeViewController: Driver<IndexPath>
    }
    
    func build(input: Input) -> Output {
        return Output(
            presentSomeViewController: input.itemSelected
        )
    }
}
