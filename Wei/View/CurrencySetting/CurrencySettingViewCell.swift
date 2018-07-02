//
//  CurrencySettingViewCell.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/06/28.
//  Copyright © 2018 yz. All rights reserved.
//

import UIKit

final class CurrencySettingViewCell: UITableViewCell, InputAppliable {
    
    @IBOutlet private weak var currencyLabel: UILabel!
    
    typealias Input = (Currency, Bool)
    
    func apply(input: Input) {
        let (currency, selectedCurrency) = input
        currencyLabel.text = currency.name
        
        let font = selectedCurrency ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 16)
        currencyLabel.font = font
        
        let color = selectedCurrency ? UIColor.wei.success : UIColor.wei.black
        currencyLabel.textColor = color
    }
}
