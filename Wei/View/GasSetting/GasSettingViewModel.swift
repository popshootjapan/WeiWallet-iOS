//
//  GasSettingViewModel.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/09/11.
//  Copyright © 2018 yz. All rights reserved.
//

import Foundation
import EthereumKit
import RxSwift
import RxCocoa

final class GasSettingViewModel: InjectableViewModel {
    
    typealias Dependency = (
        ApplicationStoreProtocol
    )
    
    private var applicationStore: ApplicationStoreProtocol
    
    init(dependency: Dependency) {
        (applicationStore) = dependency
    }
    
    struct Input {
        let sliderValue: Driver<Float>
    }
    
    struct Output {
        let initialGasPrice: Int
        let updatedGasPrice: Driver<Int>
    }
    
    func build(input: Input) -> Output {
        
        let updatedGasPrice = input.sliderValue
            .map { value -> Int in
                let intValue = Int(value * 100)
                return intValue == 0 ? 1 : intValue
            }
            .do(onNext: { [weak self] gasPrice in
                self?.applicationStore.gasPrice = gasPrice
            })
        
        return Output(
            initialGasPrice: applicationStore.gasPrice,
            updatedGasPrice: updatedGasPrice
        )
    }
}
