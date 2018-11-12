//
//  CreateWalletViewModel.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/01.
//  Copyright © 2018 popshoot All rights reserved.
//

import RxSwift
import RxCocoa
import Swinject
import CryptoSwift

final class CreateWalletViewModel: InjectableViewModel {
    
    typealias Dependency = (
        ApplicationStoreProtocol,
        WalletManagerProtocol,
        MnemonicManagerProtocol,
        RegistrationRepositoryProtocol,
        DeviceCheckerProtocol
    )
    
    private var applicationStore: ApplicationStoreProtocol
    private let walletManager: WalletManagerProtocol
    private let mnemonicManager: MnemonicManagerProtocol
    private let registrationRepository: RegistrationRepositoryProtocol
    private let deviceChecker: DeviceCheckerProtocol
    
    init(dependency: Dependency) {
        (applicationStore, walletManager, mnemonicManager, registrationRepository, deviceChecker) = dependency
    }
    
    struct Input {
        let createWalletButtonDidTap: Driver<Void>
        let restoreButtonDidTap: Driver<Void>
        let showServiceTermsButtonDidTap: Driver<Void>
    }
    
    struct Output {
        let presentAgreeServiceTermViewController: Driver<Void>
        let pushRestoreWalletViewController: Driver<Void>
        let didGenerateWallet: Driver<Void>
        let isGeneratingWallet: Driver<Bool>
        let error: Driver<Error>
    }
    
    func build(input: Input) -> Output {
        let didGenerateWalletAction = input.createWalletButtonDidTap.flatMap { [weak self] deviceToken -> Driver<Action<Void>> in
            guard let weakSelf = self else {
                return Driver.empty()
            }
            
            let signUpCompleted: Observable<String>
            if let accessToken = weakSelf.applicationStore.accessToken {
                signUpCompleted = Observable.just(accessToken)
            } else {
                signUpCompleted = weakSelf.deviceChecker.deviceToken.flatMap { deviceToken -> Observable<String> in
                    return weakSelf.registrationRepository
                        .signUp(
                            address: weakSelf.walletManager.address(),
                            sign: try weakSelf.walletManager.personalSign(message: "Welcome to Wei wallet!"),
                            token: deviceToken
                        )
                        .asObservable()
                }
            }
            
            let source = signUpCompleted
                .do(onNext: { accessToken in
                    // Store user's access token
                    weakSelf.applicationStore.accessToken = accessToken
                })
                .flatMap { _ -> Observable<Void> in
                    return weakSelf.registrationRepository.agreeServiceTerms().asObservable()
                }
            
            return Action.makeDriver(source)
        }
        
        let (didGenerateWallet, isGeneratingWallet, error) = (
            didGenerateWalletAction.elements,
            didGenerateWalletAction.isExecuting,
            didGenerateWalletAction.error
        )
        
        return Output(
            presentAgreeServiceTermViewController: input.showServiceTermsButtonDidTap,
            pushRestoreWalletViewController: input.restoreButtonDidTap,
            didGenerateWallet: didGenerateWallet,
            isGeneratingWallet: isGeneratingWallet,
            error: error
        )
    }
}
