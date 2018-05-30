//
//  CreateWalletViewModel.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/01.
//  Copyright © 2018 yz. All rights reserved.
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
        DeviceCheckerProtocol,
        APIClientProtocol
    )
    
    private var applicationStore: ApplicationStoreProtocol
    private let mnemonicManager: MnemonicManagerProtocol
    private let registrationRepository: RegistrationRepositoryProtocol
    private let deviceChecker: DeviceCheckerProtocol
    private let apiClient: APIClientProtocol
    
    init(dependency: Dependency) {
        (applicationStore, mnemonicManager, registrationRepository, deviceChecker, apiClient) = dependency
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
        let didGenerateWalletAction = input.createWalletButtonDidTap.flatMap { [weak self] deviceToken -> Driver<Action<String>> in
            guard let weakSelf = self else {
                return Driver.empty()
            }
            
            // When the wallet generation succeeds and api registration fails, there will be the case
            // that user has a seed but not registered propery. so do not double-generate wallet seed
            // to prevent it.
            if weakSelf.applicationStore.seed == nil {
                let mnemonic = weakSelf.mnemonicManager.create()
                weakSelf.applicationStore.mnemonic = mnemonic.joined(separator: " ")
                
                let seed = weakSelf.mnemonicManager.createSeed(mnemonic: mnemonic)
                weakSelf.applicationStore.seed = seed.toHexString()
            }
                
            // NOTE: To register user's address, you need the instance of wallet,
            // but because the seed is generated right before here, you can't inject
            // the instance to the ViewModel.
            let wallet = Container.shared.resolve(WalletManagerProtocol.self)!
            
            let source = weakSelf.deviceChecker.deviceToken.flatMap { deviceToken -> Observable<String> in
                return weakSelf.registrationRepository
                    .signUp(address: wallet.address(), sign: try wallet.sign(message: "Welcome to Wei wallet!"), token: deviceToken)
                    .asObservable()
            }
            
            return Action.makeDriver(source)
        }
        
        let (didGenerateWallet, isGeneratingWallet, error) = (
            didGenerateWalletAction.elements
                .do(onNext: { [weak self] accessToken in
                    self?.applicationStore.accessToken = accessToken
                })
                .map { _ in },
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
