//
//  ViewModelAssembly.swift
//  Wei
//
//  Created by yuzushioh on 2018/03/14.
//  Copyright © 2018 popshoot. All rights reserved.
//

import Swinject
import EthereumKit

final class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        
        // MARK: - RootViewModel
        
        container.register(RootViewModel.self) { resolver in
            return RootViewModel(dependency: (
                resolver.resolve(ApplicationStoreProtocol.self)!,
                resolver.resolve(AppStatusRepositoryProtocol.self)!
            ))
        }
        
        // MARK: - HomeViewModel
        
        container.register(HomeViewModel.self) { resolver in
            return HomeViewModel(dependency: (
                resolver.resolve(ApplicationStoreProtocol.self)!
            ))
        }
        
        // MARK: - CreateWalletViewModel
        
        container.register(CreateWalletViewModel.self) { resolver in
            return CreateWalletViewModel(dependency: (
                resolver.resolve(ApplicationStoreProtocol.self)!,
                resolver.resolve(MnemonicManagerProtocol.self)!,
                resolver.resolve(RegistrationRepositoryProtocol.self)!,
                resolver.resolve(DeviceCheckerProtocol.self)!,
                resolver.resolve(APIClientProtocol.self)!
            ))
        }
        
        // MARK: - RestoreWalletViewModel
        
        container.register(RestoreWalletViewModel.self) { resolver in
            return RestoreWalletViewModel(dependency: (
                resolver.resolve(ApplicationStoreProtocol.self)!,
                resolver.resolve(DeviceCheckerProtocol.self)!,
                resolver.resolve(RegistrationRepositoryProtocol.self)!,
                resolver.resolve(MnemonicManagerProtocol.self)!
            ))
        }
        
        // MARK: - MyWalletViewModel
        
        container.register(MyWalletViewModel.self) { resolver in
            return MyWalletViewModel(dependency: (
                resolver.resolve(ApplicationStoreProtocol.self)!,
                resolver.resolve(BalanceStoreProtocol.self)!,
                resolver.resolve(UpdaterProtocol.self)!
            ))
        }
        
        // MARK: - LatestTransactionListViewModel
        
        container.register(LatestTransactionListViewModel.self) { resolver in
            return LatestTransactionListViewModel(dependency: (
                resolver.resolve(WalletManagerProtocol.self)!,
                resolver.resolve(GethRepositoryProtocol.self)!,
                resolver.resolve(UpdaterProtocol.self)!,
                resolver.resolve(LocalTransactionRepositoryProtocol.self)!
            ))
        }
        
        // MARK: - SendBaseViewModel
        
        container.register(SendBaseViewModel.self) { resolver in
            return SendBaseViewModel()
        }
        
        // MARK: - SelectAddressByQRViewModel
        
        container.register(SelectAddressByQRViewModel.self) { resolver in
            return SelectAddressByQRViewModel()
        }
        
        // MARK: - SelectAddressByPasteViewModel

        container.register(SelectAddressByPasteViewModel.self) { resolver in
            return SelectAddressByPasteViewModel()
        }
        
        // MARK: - SelectAmountViewModel
        
        container.register(SelectAmountViewModel.self) { (resolver, context: TransactionContext) in
            return SelectAmountViewModel(dependency: (
                resolver.resolve(BalanceStoreProtocol.self)!,
                resolver.resolve(RateRepositoryProtocol.self)!,
                context
            ))
        }
        
        // MARK: - SendConfirmationViewModel
        
        container.register(SendConfirmationViewModel.self) { (resolver, context: TransactionContext) in
            return SendConfirmationViewModel(dependency: (
                resolver.resolve(GethRepositoryProtocol.self)!,
                resolver.resolve(WalletManagerProtocol.self)!,
                resolver.resolve(UpdaterProtocol.self)!,
                context
            ))
        }

        // MARK: - ReceiveViewModel
        
        container.register(ReceiveViewModel.self) { (resolver, delegate: QRCoderDelegate?) in
            return ReceiveViewModel(dependency: (
                resolver.resolve(WalletManagerProtocol.self)!,
                resolver.resolve(QRCoderProtocol.self, argument: delegate)!
            ))
        }
        
        // MARK: - SettingViewModel
        
        container.register(SettingViewModel.self) { (resolver) in
            return SettingViewModel()
        }
        
        // MARK: - TransactionHistoryViewModel
        
        container.register(TransactionHistoryViewModel.self) { (resolver) in
            return TransactionHistoryViewModel(dependency: (
                resolver.resolve(GethRepositoryProtocol.self)!,
                resolver.resolve(WalletManagerProtocol.self)!
            ))
        }
        
        // MARK: - TutorialViewModel
        
        container.register(TutorialViewModel.self) { (resolver) in
            return TutorialViewModel()
        }
        
        // MARK: - BackupViewModel
        
        container.register(BackupViewModel.self) { (resolver) in
            return BackupViewModel(dependency: (
                resolver.resolve(ApplicationStoreProtocol.self)!
            ))
        }
        
        // MARK: - SuggestBackupViewModel
        
        container.register(SuggestBackupViewModel.self) { (resolver) in
            return SuggestBackupViewModel()
        }
    }
}
