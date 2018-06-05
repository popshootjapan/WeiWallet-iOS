//
//  UIViewController.Container+Extension.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/04/14.
//  Copyright © 2018 yz. All rights reserved.
//

import Swinject
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

extension AgreeServiceTermsViewController {
    static func make() -> AgreeServiceTermsViewController {
        return Container.shared.resolve(AgreeServiceTermsViewController.self)!
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
    static func make(_ address: String) -> SelectAmountViewController {
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

extension AdjustGasPriceViewController {
    static func make() -> AdjustGasPriceViewController {
        return Container.shared.resolve(AdjustGasPriceViewController.self)!
    }
}
