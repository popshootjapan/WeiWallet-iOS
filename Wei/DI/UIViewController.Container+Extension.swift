//
//  UIViewController.Container+Extension.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/04/14.
//  Copyright © 2018 popshoot All rights reserved.
//

import Swinject
import EthereumKit
import UIKit

extension RootViewController {
    static func make() -> RootViewController {
        return Container.shared.resolve(RootViewController.self)!
    }
}

extension SwipableViewController {
    static func make(viewControllers: [UIViewController], titles: [String]) -> SwipableViewController {
        return Container.shared.resolve(SwipableViewController.self, arguments: viewControllers, titles)!
    }
}

extension HomeViewController {
    static func make() -> HomeViewController {
        return Container.shared.resolve(HomeViewController.self)!
    }
}

extension MyWalletViewController {
    static func make() -> MyWalletViewController {
        return Container.shared.resolve(MyWalletViewController.self)!
    }
}

extension LatestTransactionListViewController {
    static func make() -> LatestTransactionListViewController {
        return Container.shared.resolve(LatestTransactionListViewController.self)!
    }
}

extension BrowserViewController {
    static func make() -> BrowserViewController {
        return Container.shared.resolve(BrowserViewController.self)!
    }
}

extension CreateWalletViewController {
    static func make() -> CreateWalletViewController {
        return Container.shared.resolve(CreateWalletViewController.self)!
    }
}

extension RestoreWalletViewController {
    static func make() -> RestoreWalletViewController {
        return Container.shared.resolve(RestoreWalletViewController.self)!
    }
}

extension SendBaseViewController {
    static func make() -> SendBaseViewController {
        return Container.shared.resolve(SendBaseViewController.self)!
    }
}

extension SelectAddressByQRViewController {
    static func make() -> SelectAddressByQRViewController {
        return Container.shared.resolve(SelectAddressByQRViewController.self)!
    }
}

extension SelectAddressByPasteViewController {
    static func make() -> SelectAddressByPasteViewController {
        return Container.shared.resolve(SelectAddressByPasteViewController.self)!
    }
}

extension SelectAmountViewController {
    static func make(address: String) -> SelectAmountViewController {
        return Container.shared.resolve(SelectAmountViewController.self, argument: address)!
    }
}

extension SendConfirmationViewController {
    static func make(_ transactionContext: TransactionContext) -> SendConfirmationViewController {
        return Container.shared.resolve(SendConfirmationViewController.self, argument: transactionContext)!
    }
}

extension ReceiveViewController {
    static func make() -> ReceiveViewController {
        return Container.shared.resolve(ReceiveViewController.self)!
    }
}

extension SettingViewController {
    static func make() -> SettingViewController {
        return Container.shared.resolve(SettingViewController.self)!
    }
}

extension CurrencySettingViewController {
    static func make() -> CurrencySettingViewController {
        return Container.shared.resolve(CurrencySettingViewController.self)!
    }
}

extension NetworkSettingViewController {
    static func make() -> NetworkSettingViewController {
        return Container.shared.resolve(NetworkSettingViewController.self)!
    }
}

extension PublicNetworkSettingViewController {
    static func make() -> PublicNetworkSettingViewController {
        return Container.shared.resolve(PublicNetworkSettingViewController.self)!
    }
}

extension PrivateNetworkSettingViewController {
    static func make() -> PrivateNetworkSettingViewController {
        return Container.shared.resolve(PrivateNetworkSettingViewController.self)!
    }
}

extension TransactionHistoryViewController {
    static func make() -> TransactionHistoryViewController {
        return Container.shared.resolve(TransactionHistoryViewController.self)!
    }
}

extension TutorialViewController {
    static func make() -> TutorialViewController {
        return Container.shared.resolve(TutorialViewController.self)!
    }
}

extension MaintenanceViewController {
    static func make() -> MaintenanceViewController {
        return Container.shared.resolve(MaintenanceViewController.self)!
    }
}

extension DebugListViewController {
    static func make() -> DebugListViewController {
        return Container.shared.resolve(DebugListViewController.self)!
    }
}

extension BackupViewController {
    static func make() -> BackupViewController {
        return Container.shared.resolve(BackupViewController.self)!
    }
}

extension SuggestBackupViewController {
    static func make() -> SuggestBackupViewController {
        return Container.shared.resolve(SuggestBackupViewController.self)!
    }
}

extension UpdateServiceTermsViewController {
    static func make() -> UpdateServiceTermsViewController {
        return Container.shared.resolve(UpdateServiceTermsViewController.self)!
    }
}

extension SignTransactionViewController {
    static func make(rawTransaction: RawTransaction, actionKind: SignTransactionViewModel.ActionKind,
                     completionHandler: @escaping ((String) -> Void)) -> SignTransactionViewController {
        return Container.shared.resolve(SignTransactionViewController.self, arguments: rawTransaction, actionKind, completionHandler)!
    }
}

extension GasSettingViewController {
    static func make() -> GasSettingViewController {
        return Container.shared.resolve(GasSettingViewController.self)!
    }
}
