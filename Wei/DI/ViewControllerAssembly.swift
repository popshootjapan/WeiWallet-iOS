//
//  ViewControllerAssembly.swift
//  Wei
//
//  Created by yuzushioh on 2018/03/11.
//  Copyright © 2018 popshoot. All rights reserved.
//

import UIKit
import Swinject

final class ViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        
        // MARK: - RootViewController
        
        container.register(RootViewController.self) { resolver in
            let viewController = RootViewController()
            viewController.viewModel = resolver.resolve(RootViewModel.self)!
            return viewController
        }
        
        // MARK: - SwipableViewController
        
        container.register(SwipableViewController.self) { (resolver, viewControllers: [UIViewController], titles: [String]) in
            let viewController = UIStoryboard.instantiateViewController(of: SwipableViewController.self)
            viewController.viewControllers = viewControllers
            viewController.titles = titles
            return viewController
        }
        
        // MARK: - HomeViewController
        
        container.register(HomeViewController.self) { resolver in
            let viewController = UIStoryboard.instantiateViewController(of: HomeViewController.self)
            viewController.viewModel = resolver.resolve(HomeViewModel.self)!
            return viewController
        }
        
        // MARK: - MyWalletViewController
        
        container.register(MyWalletViewController.self) { resolver in
            let viewController = UIStoryboard.instantiateViewController(of: MyWalletViewController.self)
            viewController.viewModel = resolver.resolve(MyWalletViewModel.self)!
            return viewController
        }
        
        // MARK: - LatestTransactionListViewController
        
        container.register(LatestTransactionListViewController.self) { resolver in
            let viewController = UIStoryboard.instantiateViewController(of: LatestTransactionListViewController.self)
            viewController.viewModel = resolver.resolve(LatestTransactionListViewModel.self)!
            return viewController
        }
        
        // MARK: - CreateWalletViewController
        
        container.register(CreateWalletViewController.self) { resolver in
            let viewController = UIStoryboard.instantiateViewController(of: CreateWalletViewController.self)
            viewController.viewModel = resolver.resolve(CreateWalletViewModel.self)!
            return viewController
        }
        
        // MARK: - RestoreWalletViewController
        
        container.register(RestoreWalletViewController.self) { resolver in
            let viewController = UIStoryboard.instantiateViewController(of: RestoreWalletViewController.self)
            viewController.viewModel = resolver.resolve(RestoreWalletViewModel.self)!
            return viewController
        }
        
        // MARK: - AgreeServiceTermsViewController
        
        container.register(AgreeServiceTermsViewController.self) { resolver in
            return UIStoryboard.instantiateViewController(of: AgreeServiceTermsViewController.self)
        }
        
        // MARK: - SendBaseViewController
        
        container.register(SendBaseViewController.self) { resolver in
            let viewController = UIStoryboard.instantiateViewController(of: SendBaseViewController.self)
            viewController.viewModel = resolver.resolve(SendBaseViewModel.self)!
            return viewController
        }
        
        // MARK: - SelectAddressByQRViewController
        
        container.register(SelectAddressByQRViewController.self) { resolver in
            let viewController = UIStoryboard.instantiateViewController(of: SelectAddressByQRViewController.self)
            viewController.viewModel = resolver.resolve(SelectAddressByQRViewModel.self)!
            return viewController
        }
        
        // MARK: - SelectAddressByPasteViewController
        
        container.register(SelectAddressByPasteViewController.self) { resolver in
            let viewController = UIStoryboard.instantiateViewController(of: SelectAddressByPasteViewController.self)
            viewController.viewModel = resolver.resolve(SelectAddressByPasteViewModel.self)!
            return viewController
        }
        
        // MARK: - SelectAmountViewController
        
        container.register(SelectAmountViewController.self) { (resolver, address: String) in
            let viewController = UIStoryboard.instantiateViewController(of: SelectAmountViewController.self)
            viewController.viewModel = resolver.resolve(SelectAmountViewModel.self, argument: address)!
            return viewController
        }
        
        // MARK: - SendConfirmationViewController
        
        container.register(SendConfirmationViewController.self) { (resolver, context: TransactionContext) in
            let viewController = UIStoryboard.instantiateViewController(of: SendConfirmationViewController.self)
            viewController.viewModel = resolver.resolve(SendConfirmationViewModel.self, argument: context)!
            return viewController
        }

        // MARK: - ReceiveViewController
        
        container.register(ReceiveViewController.self) { resolver in
            let viewController = UIStoryboard.instantiateViewController(of: ReceiveViewController.self)
            viewController.viewModel = resolver.resolve(ReceiveViewModel.self, argument: Optional<QRCoderDelegate>.none)!
            return viewController
        }
        
        // MARK: - SettingViewController
        
        container.register(SettingViewController.self) { resolver in
            let viewController = UIStoryboard.instantiateViewController(of: SettingViewController.self)
            viewController.viewModel = resolver.resolve(SettingViewModel.self)!
            return viewController
        }
        
        // MARK: - TransactionHistoryViewController
        
        container.register(TransactionHistoryViewController.self) { resolver in
            let viewController = UIStoryboard.instantiateViewController(of: TransactionHistoryViewController.self)
            viewController.viewModel = resolver.resolve(TransactionHistoryViewModel.self)!
            return viewController
        }
        
        // MARK: - TutorialViewController
        
        container.register(TutorialViewController.self) { resolver in
            let viewController = UIStoryboard.instantiateViewController(of: TutorialViewController.self)
             viewController.viewModel = resolver.resolve(TutorialViewModel.self)!
            return viewController
        }
        
        // MARK: - MaintenanceViewController
        
        container.register(MaintenanceViewController.self) { resolver in
            return UIStoryboard.instantiateViewController(of: MaintenanceViewController.self)
        }
        
        // MARK : - DebugListViewController
        
        container.register(DebugListViewController.self) { resolver in
            return UIStoryboard.instantiateViewController(of: DebugListViewController.self)
        }
        
        // MARK: - BackupViewController
        
        container.register(BackupViewController.self) { resolver in
            let viewController = UIStoryboard.instantiateViewController(of: BackupViewController.self)
            viewController.viewModel = resolver.resolve(BackupViewModel.self)!
            return viewController
        }
        
        // MARK: - SuggestBackupViewController
        
        container.register(SuggestBackupViewController.self) { resolver in
            let viewController = UIStoryboard.instantiateViewController(of: SuggestBackupViewController.self)
            viewController.viewModel = resolver.resolve(SuggestBackupViewModel.self)!
            return viewController
        }
        
        // MARK: - AdjustGasPriceViewController
        
        container.register(AdjustGasPriceViewController.self) { resolver in
            let viewController = UIStoryboard.instantiateViewController(of: AdjustGasPriceViewController.self)
            viewController.viewModel = resolver.resolve(AdjustGasPriceViewModel.self)!
            return viewController
        }
    }
}

