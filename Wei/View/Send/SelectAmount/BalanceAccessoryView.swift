//
//  BalanceAccessoryView.swift
//  Wei
//
//  Created by omatty198 on 2018/04/11.
//  Copyright © 2018年 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class BalanceAccessoryView: UIView, InputAppliable {

    @IBOutlet private weak var availableBalanceLabel: UILabel!
    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var fiatUnitLabel: UILabel!
    @IBOutlet private weak var txFeeLabel: UILabel!

    enum Input {
        case availableBalance(Fiat)
        case balance(Fiat)
        case txFee(Fiat)
    }
    
    func apply(input: Input) {
        // TODO: fix currency code
        switch input {
        case .availableBalance(let amount):
            availableBalanceLabel.text = String(amount.value.description)
        case .balance(let amount):
            balanceLabel.text = String(amount.value.description)
        case .txFee(let amount):
            txFeeLabel.text = String(amount.value.description)
        }
    }
}
