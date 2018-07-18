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
        MnemonicManagerProtocol,
        RegistrationRepositoryProtocol,
        DeviceCheckerProtocol
    )
    
    private var applicationStore: ApplicationStoreProtocol
    private let mnemonicManager: MnemonicManagerProtocol
    private let registrationRepository: RegistrationRepositoryProtocol
    private let deviceChecker: DeviceCheckerProtocol
    
    init(dependency: Dependency) {
        (applicationStore, mnemonicManager, registrationRepository, deviceChecker) = dependency
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
            
            // When the wallet generation succeeds and api registration fails, there will be the case
            // that user has a seed but not registered propery. so do not double-generate wallet seed
            // to prevent it.
            if weakSelf.applicationStore.seed == nil {
                let mnemonic = weakSelf.mnemonicManager.create()
                let seed: String
                do {
                    seed = try weakSelf.mnemonicManager.createSeed(mnemonic: mnemonic).toHexString()
                } catch let error {
                    return Driver.just(Action.failed(error))
                }
                weakSelf.applicationStore.mnemonic = mnemonic.joined(separator: " ")
                weakSelf.applicationStore.seed = seed
            }
                
            // NOTE: To register user's address, you need the instance of wallet,
            // but because the seed is generated right before here, you can't inject
            // the instance to the ViewModel.
            let wallet = Container.shared.resolve(WalletManagerProtocol.self)!
            
            let signUpCompleted: Observable<String>
            if weakSelf.applicationStore.accessToken == nil {
                signUpCompleted = weakSelf.deviceChecker.deviceToken.flatMap { deviceToken -> Observable<String> in
                    return weakSelf.registrationRepository
                        .signUp(address: wallet.address(), sign: try wallet.sign(message: "Welcome to Wei wallet!"), token: deviceToken)
                        .asObservable()
                }
            } else {
                signUpCompleted = Observable.just(weakSelf.applicationStore.accessToken!)
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
