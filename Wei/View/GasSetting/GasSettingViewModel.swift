//
//  GasSettingViewModel.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/09/11.
//  Copyright © 2018 yz. All rights reserved.
//

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
        
    }
    
    struct Output {
        
    }
    
    func build(input: Input) -> Output {
        return Output()
    }
}
