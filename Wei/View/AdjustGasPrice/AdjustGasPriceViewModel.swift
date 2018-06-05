//
//  AdjustGasPriceViewModel.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/06/06.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class AdjustGasPriceViewModel: InjectableViewModel {
    
    typealias Dependency = (
        ApplicationStoreProtocol
    )
    
    private var applicationStore: ApplicationStoreProtocol
    
    init(dependency: Dependency) {
        applicationStore = dependency
    }
    
    struct Input {
        let updatedGasPrice: Driver<Int>
    }
    
    struct Output {
        let gasPrice: Driver<Int>
    }
    
    func build(input: Input) -> Output {
        let gasPrice = input.updatedGasPrice
            .do(onNext: { [weak self] in self?.applicationStore.gasPrice = $0 })
            .startWith(applicationStore.gasPrice)
        
        return Output(gasPrice: gasPrice)
    }
}
