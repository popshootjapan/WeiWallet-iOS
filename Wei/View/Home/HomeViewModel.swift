//
//  HomeViewModel.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/01.
//  Copyright © 2018 popshoot All rights reserved.
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
        let receiveButtonDidTap: Driver<Void>
    }
    
    struct Output {
        let presentReceiveViewController: Driver<Void>
    }
    
    func build(input: Input) -> Output {
        return Output(
            presentReceiveViewController: input.receiveButtonDidTap
        )
    }
}
