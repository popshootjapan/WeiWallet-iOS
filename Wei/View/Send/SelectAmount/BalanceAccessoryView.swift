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
    @IBOutlet private weak var txFeeLabel: UILabel!

    enum Input {
        case availableBalance(Fiat, Currency)
        case balance(Fiat, Currency)
        case txFee(Fiat, Currency)
    }
    
    func apply(input: Input) {
        switch input {
        case .availableBalance(let amount, let currency):
            availableBalanceLabel.text = Formatter.priceString(from: amount.value as NSDecimalNumber, currency: currency)
        case .balance(let amount, let currency):
            balanceLabel.text = Formatter.priceString(from: amount.value as NSDecimalNumber, currency: currency)
        case .txFee(let amount, let currency):
            txFeeLabel.text = Formatter.priceString(from: amount.value as NSDecimalNumber, currency: currency)
        }
    }
}
