//
//  SignTransactionViewModel.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/08/02.
//  Copyright © 2018 yz. All rights reserved.
//

import RxSwift
import RxCocoa
import EthereumKit

final class SignTransactionViewModel: InjectableViewModel {
    
    var rawTransaction: RawTransaction!
    
    typealias Dependency = (
        WalletManagerProtocol
    )
    
    private let walletManager: WalletManagerProtocol
    
    init(dependency: Dependency) {
        (walletManager) = dependency
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func build(input: Input) -> Output {
        return Output()
    }
}
