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
    private let disposeBag: DisposeBag
    
    init(dependency: Dependency) {
        applicationStore = dependency
        disposeBag = DisposeBag()
    }
    
    struct Input {
        let selectedIndexPath: Driver<IndexPath>
    }
    
    struct Output {
        let networks: Driver<[(Network, Bool)]>
    }
    
    func build(input: Input) -> Output {
        let selectedNetwork = applicationStore.network
        
        input
            .selectedIndexPath
            .drive(onNext: { [weak self] indexPath in
                let network = Network.all[indexPath.row]
                self?.applicationStore.network = network
                self?.applicationStore.clearData()
                AppDelegate.rootViewController.showHomeViewController()
            })
            .disposed(by: disposeBag)
        
        return Output(
            networks: Driver.just(Network.all.map { ($0, $0 == selectedNetwork) })
        )
    }
}
