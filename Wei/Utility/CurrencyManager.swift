//
//  CurrencyManager.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/06/13.
//  Copyright © 2018 yz. All rights reserved.
//

import RxSwift
import RxCocoa

protocol CurrencyManagerProtocol {
}

final class CurrencyManager: CurrencyManagerProtocol, Injectable {
    
    typealias Dependency = (
        ApplicationStoreProtocol
    )
    
    init(dependency: Dependency) {
        
    }
}
