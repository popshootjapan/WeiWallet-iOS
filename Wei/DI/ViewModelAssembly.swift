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
                resolver.resolve(WalletManagerProtocol.self)!,
                resolver.resolve(MnemonicManagerProtocol.self)!,
                resolver.resolve(RegistrationRepositoryProtocol.self)!,
                resolver.resolve(DeviceCheckerProtocol.self)!
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
                resolver.resolve(UpdaterProtocol.self)!,
                resolver.resolve(CurrencyManagerProtocol.self)!
            ))
        }
        
        // MARK: - LatestTransactionListViewModel
        
        container.register(LatestTransactionListViewModel.self) { resolver in
            return LatestTransactionListViewModel(dependency: (
                resolver.resolve(WalletManagerProtocol.self)!,
                resolver.resolve(GethRepositoryProtocol.self)!,
                resolver.resolve(UpdaterProtocol.self)!,
                resolver.resolve(CacheProtocol.self)!,
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
        
        container.register(SelectAmountViewModel.self) { (resolver, address: String) in
            let viewModel = SelectAmountViewModel(dependency: (
                resolver.resolve(ApplicationStoreProtocol.self)!,
                resolver.resolve(BalanceStoreProtocol.self)!,
                resolver.resolve(RateRepositoryProtocol.self)!,
                resolver.resolve(CurrencyManagerProtocol.self)!
            ))
            
            viewModel.toAddress = address
            return viewModel
        }
        
        // MARK: - SendConfirmationViewModel
        
        container.register(SendConfirmationViewModel.self) { (resolver, context: TransactionContext) in
            return SendConfirmationViewModel(dependency: (
                resolver.resolve(ApplicationStoreProtocol.self)!,
                resolver.resolve(GethRepositoryProtocol.self)!,
                resolver.resolve(WalletManagerProtocol.self)!,
                resolver.resolve(UpdaterProtocol.self)!,
                resolver.resolve(LocalTransactionRepositoryProtocol.self)!,
                resolver.resolve(CurrencyManagerProtocol.self)!,
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
        
        // MARK: - CurrencySettingViewModel
        
        container.register(CurrencySettingViewModel.self) { resolver in
            return CurrencySettingViewModel(dependency: (
                resolver.resolve(CurrencyManagerProtocol.self)!
            ))
        }
        
        // MARK: - PublicNetworkSettingViewModel
        
        container.register(PublicNetworkSettingViewModel.self) { resolver in
            return PublicNetworkSettingViewModel(dependency: (
                resolver.resolve(ApplicationStoreProtocol.self)!
            ))
        }
        
        // MARK: - TransactionHistoryViewModel
        
        container.register(TransactionHistoryViewModel.self) { (resolver) in
            return TransactionHistoryViewModel(dependency: (
                resolver.resolve(GethRepositoryProtocol.self)!,
                resolver.resolve(WalletManagerProtocol.self)!,
                resolver.resolve(CacheProtocol.self)!
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
        
        // MARK: - UpdateServiceTermsViewModel
        
        container.register(UpdateServiceTermsViewModel.self) { resolver in
            return UpdateServiceTermsViewModel(dependency: (
                resolver.resolve(RegistrationRepositoryProtocol.self)!
            ))
        }
        
        // MARK: - SignTransactionViewModel
        
        container.register(SignTransactionViewModel.self) { (resolver, rawTransaction: RawTransaction, actionKind: SignTransactionViewModel.ActionKind) in
            let viewModel = SignTransactionViewModel(dependency: (
                resolver.resolve(ApplicationStoreProtocol.self)!,
                resolver.resolve(WalletManagerProtocol.self)!,
                resolver.resolve(CurrencyManagerProtocol.self)!,
                resolver.resolve(RateRepositoryProtocol.self)!,
                resolver.resolve(GethRepositoryProtocol.self)!
            ))
            viewModel.rawTransaction = rawTransaction
            viewModel.actionKind = actionKind
            return viewModel
        }
        
        // MARK: - GasSettingViewModel
        
        container.register(GasSettingViewModel.self) { resolver in
            return GasSettingViewModel(dependency: (
                resolver.resolve(ApplicationStoreProtocol.self)!
            ))
        }
        
        // MARK: - PrivateNetworkSettingViewModel
        
        container.register(PrivateNetworkSettingViewModel.self) { resolver in
            return PrivateNetworkSettingViewModel(dependency: (
                resolver.resolve(ApplicationStoreProtocol.self)!
            ))
        }
    }
}
