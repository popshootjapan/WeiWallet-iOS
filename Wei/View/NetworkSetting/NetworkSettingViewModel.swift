//
//  NetworkSettingViewModel.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/07/06.
//  Copyright © 2018 yz. All rights reserved.
//

import RxSwift
import RxCocoa

final class NetworkSettingViewModel: InjectableViewModel {
    
    typealias Dependency = (
        ApplicationStoreProtocol
    )
    
    private var applicationStore: ApplicationStoreProtocol
    
    init(dependency: Dependency) {
        applicationStore = dependency
    }
    
    struct Input {
        let selectedNetwork: Driver<Network>
    }
    
    struct Output {
        let networks: Driver<[(Network, Bool)]>
    }
    
    func build(input: Input) -> Output {
        return Output(
            networks: Driver.just(Network.all.map { ($0, false) })
        )
    }
}
