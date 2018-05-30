//
//  HomeViewModel.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/01.
//  Copyright © 2018 yz. All rights reserved.
//

import RxSwift
import RxCocoa

final class HomeViewModel: InjectableViewModel {
    
    typealias Dependency = (
        ApplicationStoreProtocol
    )
    
    private let applicationStore: ApplicationStoreProtocol
    
    init(dependency: Dependency) {
        applicationStore = dependency
    }
    
    struct Input {
        let settingButtonDidTap: Driver<Void>
        let receiveButtonDidTap: Driver<Void>
    }
    
    struct Output {
        let pushSettingViewController: Driver<Void>
        let presentReceiveViewController: Driver<Void>
    }
    
    func build(input: Input) -> Output {
        return Output(
            pushSettingViewController: input.settingButtonDidTap,
            presentReceiveViewController: input.receiveButtonDidTap
        )
    }
}
