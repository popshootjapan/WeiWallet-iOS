//
//  RootViewModel.swift
//  Wei
//
//  Created by yuzushioh on 2018/03/14.
//  Copyright © 2018 popshoot. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class RootViewModel: InjectableViewModel {
    
    typealias Dependency = (
        ApplicationStoreProtocol,
        AppStatusRepositoryProtocol
    )
    
    private let applicationStore: ApplicationStoreProtocol
    private let appStatusRepository: AppStatusRepositoryProtocol
    
    init(dependency: Dependency) {
        (applicationStore, appStatusRepository) = dependency
    }
    
    struct Input {
        let viewWillAppear: Driver<Void>
        let viewDidAppear: Driver<Void>
    }
    
    struct Output {
        let showTabBarController: Driver<Void>
        let presentCreateWalletViewController: Driver<Void>
        let presentMaintenanceViewController: Driver<Void>
        let presentAppStoreForForceUpdates: Driver<Void>
        let presentAgreeTermsViewController: Driver<Void>
    }
    
    func build(input: Input) -> Output {
        let applicationStore = self.applicationStore
        
        let appStatusAction = input.viewWillAppear
            .filter { applicationStore.accessToken != nil }
            .flatMap { [weak self] _ -> Driver<Action<AppStatus>> in
                guard let weakSelf = self else {
                    return Driver.empty()
                }
                let source = weakSelf.appStatusRepository.getAppStatus().retry(10)
                return Action.makeDriver(source)
            }
        
        let appStatus = appStatusAction.elements
        
        let presentMaintenanceViewController = appStatus
            .filter { $0.isUnderMaintenance }
            .map { _ in }
        
        let presentAppStoreForForceUpdates = appStatus
            .filter { $0.forceUpdates }
            .map { _ in }
        
        let presentAgreeTermsViewController = appStatus
            .filter { $0.needsAgreeTerms }
            .map { _ in }
        
        let showTabBarController = input.viewWillAppear
            .filter { applicationStore.seed != nil && applicationStore.accessToken != nil }
        
        // NOTE: app needs to show create wallet view controller if app does not have
        // the seed or access token. This case will happen if seed is saved in the keychain
        // from other apps developed by us.
        let presentCreateWalletViewController = input.viewDidAppear
            .filter { applicationStore.accessToken == nil }
        
        return Output(
            showTabBarController: showTabBarController,
            presentCreateWalletViewController: presentCreateWalletViewController,
            presentMaintenanceViewController: presentMaintenanceViewController,
            presentAppStoreForForceUpdates: presentAppStoreForForceUpdates,
            presentAgreeTermsViewController: presentAgreeTermsViewController
        )
    }
}
