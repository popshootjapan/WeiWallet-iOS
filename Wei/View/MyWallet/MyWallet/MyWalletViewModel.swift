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
        UpdaterProtocol
    )
    
    private let applicationStore: ApplicationStoreProtocol
    private let balanceStore: BalanceStoreProtocol
    private let updater: UpdaterProtocol
    
    init(dependency: Dependency) {
        (applicationStore, balanceStore, updater) = dependency
    }
    
    struct Input {
        let viewWillAppear: Driver<Void>
        let sendButtonDidTap: Driver<Void>
        let historyButtonDidTap: Driver<Void>
    }
    
    struct Output {
        let etherBalance: Driver<Balance>
        let fiatBalance: Driver<String>
        let error: Driver<Error>
        let presentSendViewController: Driver<Void>
        let pushTransactionHistoryViewController: Driver<Void>
        let presentSuggestBackupViewController: Driver<Void>
    }
    
    func build(input: Input) -> Output {
        let applicationStore = self.applicationStore
        
        let getEtherBalanceAction = Action.makeDriver(balanceStore.etherBalance)
        let etherBalance = getEtherBalanceAction.elements
        
        let getFiatBalanceAction = Action.makeDriver(balanceStore.fiatBalance)
        let fiatBalance = getFiatBalanceAction.elements
        
        let suggestBackup = input.viewWillAppear
            .filter { !applicationStore.isAlreadyBackup }
            .flatMap { fiatBalance.asObservable().take(1).asDriver(onErrorDriveWith: .empty()) }
            .filter { Int($0) ?? 0 >= 3000 }
            .map { _ in }
        
        return Output(
            etherBalance: etherBalance,
            fiatBalance: fiatBalance,
            error: getEtherBalanceAction.error,
            presentSendViewController: input.sendButtonDidTap,
            pushTransactionHistoryViewController: input.historyButtonDidTap,
            presentSuggestBackupViewController: suggestBackup
        )
    }
}
