//
//  MyWalletViewModel.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/01.
//  Copyright © 2018 popshoot All rights reserved.
//

import EthereumKit
import RxSwift
import RxCocoa

final class MyWalletViewModel: InjectableViewModel {
    
    typealias Dependency = (
        ApplicationStoreProtocol,
        BalanceStoreProtocol,
        UpdaterProtocol,
        CurrencyManagerProtocol
    )
    
    private let applicationStore: ApplicationStoreProtocol
    private let balanceStore: BalanceStoreProtocol
    private let updater: UpdaterProtocol
    private let currencyManager: CurrencyManagerProtocol
    
    init(dependency: Dependency) {
        (applicationStore, balanceStore, updater, currencyManager) = dependency
    }
    
    struct Input {
        let viewWillAppear: Driver<Void>
        let sendButtonDidTap: Driver<Void>
        let historyButtonDidTap: Driver<Void>
    }
    
    struct Output {
        let etherBalance: Driver<Balance>
        let fiatBalance: Driver<Fiat>
        let error: Driver<Error>
        let currency: Driver<Currency>
        let network: Driver<Network>
        let presentSendViewController: Driver<Void>
        let pushTransactionHistoryViewController: Driver<Void>
        let presentSuggestBackupViewController: Driver<Void>
    }
    
    func build(input: Input) -> Output {
        let applicationStore = self.applicationStore
        let currency = currencyManager.currency.asDriver(onErrorDriveWith: .empty())
        
        let getEtherBalanceAction = Action.makeDriver(balanceStore.etherBalance)
        let etherBalance = getEtherBalanceAction.elements
        
        let getFiatBalanceAction = Action.makeDriver(balanceStore.fiatBalance)
        let fiatBalance = getFiatBalanceAction.elements
        
        let suggestBackup = input.viewWillAppear
            .filter { !applicationStore.isAlreadyBackup }
            .flatMap { fiatBalance.asObservable().take(1).asDriver(onErrorDriveWith: .empty()) }
            .withLatestFrom(currency) { $0.value >= $1.showBackupPopupAmount }
            .filter { $0 }
            .map { _ in }
        
        return Output(
            etherBalance: etherBalance,
            fiatBalance: fiatBalance,
            error: getEtherBalanceAction.error,
            currency: currency,
            network: Driver.just(applicationStore.network),
            presentSendViewController: input.sendButtonDidTap,
            pushTransactionHistoryViewController: input.historyButtonDidTap,
            presentSuggestBackupViewController: suggestBackup
        )
    }
}
