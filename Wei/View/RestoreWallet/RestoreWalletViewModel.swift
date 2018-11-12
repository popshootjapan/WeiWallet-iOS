//
//  RestoreWalletViewModel.swift
//  Wei
//
//  Created by yuzushioh on 2018/05/22.
//  Copyright © 2018 popshoot All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import EthereumKit
import Swinject

final class RestoreWalletViewModel: InjectableViewModel {
    
    typealias Dependency = (
        ApplicationStoreProtocol,
        DeviceCheckerProtocol,
        RegistrationRepositoryProtocol,
        MnemonicManagerProtocol
    )
    
    private var applicationStore: ApplicationStoreProtocol
    private let deviceChecker: DeviceCheckerProtocol
    private let registrationRepository: RegistrationRepositoryProtocol
    private let mnemonicManager: MnemonicManagerProtocol
    
    init(dependency: Dependency) {
        (applicationStore, deviceChecker, registrationRepository, mnemonicManager) = dependency
    }
    
    struct Input {
        let words: [Driver<String>]
        let confirmButtonDidTap: Driver<Void>
    }
    
    struct Output {
        let isConfirmButtonEnabled: Driver<Bool>
        let dismissViewController: Driver<Void>
        let invalidMnemonic: Driver<Void>
        let isExecuting: Driver<Bool>
    }
    
    func build(input: Input) -> Output {
        let mnemonicWords = Driver.combineLatest(input.words)
        let isConfirmButtonEnabled = mnemonicWords
            // enable confirm button if and only if ann array of words contains no true(isEmpty).
            .map { !$0.map { $0.isEmpty }.contains(true) }
            .distinctUntilChanged()
        
        let restoreWalletAction = input.confirmButtonDidTap
            .withLatestFrom(mnemonicWords)
            .flatMap { [weak self] mnemonic -> Driver<Action<String>> in
                guard let weakSelf = self else {
                    return Driver.empty()
                }
                
                let seed: String
                do {
                    seed = try weakSelf.mnemonicManager.createSeed(mnemonic: mnemonic).toHexString()
                } catch let error {
                    return Driver.just(Action.failed(error))
                }
                
                // If generated seed string is empty, it indicates that mnemonic words are incorrect.
                // in this case returns Action.failed to handle error.
                guard !seed.isEmpty else {
                    return Driver.just(Action.failed(EthereumKitError.cryptoError(.keyDerivateionFailed)))
                }
                
                // Save mnemonic words and seed string in keychain
                weakSelf.applicationStore.mnemonic = mnemonic.joined(separator: " ")
                weakSelf.applicationStore.seed = seed
                
                // when restored, it is certain that user has a backup
                weakSelf.applicationStore.isAlreadyBackup = true
                
                let wallet = Container.shared.resolve(WalletManagerProtocol.self)!
                
                let source = weakSelf.deviceChecker.deviceToken.flatMap { deviceToken -> Observable<String> in
                    return weakSelf.registrationRepository
                        .signUp(address: wallet.address(), sign: try wallet.personalSign(message: "Welcome to Wei wallet!"), token: deviceToken)
                        .asObservable()
                }
                
                return Action.makeDriver(source)
            }
        
        // If seed is not empty string, then save seed string in keychain
        // and dismiss view controller
        let dismissViewController = restoreWalletAction.elements
            .do(onNext: { [weak self] in self?.applicationStore.accessToken = $0 })
            .map { _ in }
        
        // If restoreWalletAction.error emits, it indicates that it has failed to restore seed
        // from provided mnemonic words. show alert in view controller.
        let invalidMnemonic = restoreWalletAction.error
            .map { _ in }
        
        return Output(
            isConfirmButtonEnabled: isConfirmButtonEnabled,
            dismissViewController: dismissViewController,
            invalidMnemonic: invalidMnemonic,
            isExecuting: restoreWalletAction.isExecuting
        )
    }
}
