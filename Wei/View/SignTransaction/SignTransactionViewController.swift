//
//  SignTransactionViewController.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/08/02.
//  Copyright © 2018 yz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let output = viewModel.build(input: SignTransactionViewModel.Input(
            cancelButtonDidTap: cancelButton.rx.tap.asDriver(),
            doneButtonDidTap: doneButton.rx.tap.asDriver()
        ))
        
        output
            .dismissViewController
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        output
            .currency
            .drive(onNext: { [weak self] currency in
                self?.updateCurrency(currency)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateCurrency(_ currency: Currency) {
        fiatCurrencyLabels.forEach { $0.text = currency.unit }
    }
}
