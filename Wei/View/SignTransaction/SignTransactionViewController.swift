//
//  SignTransactionViewController.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/08/02.
//  Copyright © 2018 yz. All rights reserved.
//

import UIKit

final class SignTransactionViewController: UIViewController {
    
    var completionHandler: ((String) -> Void)!
    var viewModel: SignTransactionViewModel!
    
    
    
    @IBOutlet private var fiatAmountLabels: [UILabel]!
    @IBOutlet private var fiatFeeLabels: [UILabel]!
    @IBOutlet private var fiatCurrencyLabels: [UILabel]!
    @IBOutlet private weak var etherAmountLabel: UILabel!
    @IBOutlet private weak var toAddressLabel: UILabel!
    @IBOutlet private weak var fiatEtherLabel: UILabel!
    @IBOutlet private weak var totalFiatAmountLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIBarButtonItem!
    @IBOutlet private weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
