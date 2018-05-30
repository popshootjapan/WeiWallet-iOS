//
//  SelectAmountViewController.swift
//  Wei
//
//  Created by omatty198 on 2018/04/02.
//  Copyright © 2018年 yz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectAmountViewController: UIViewController {

    var viewModel: SelectAmountViewModel!

    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var etherAmountLabel: UILabel!
    @IBOutlet private weak var confirmButton: UIButton!
    
    lazy var balanceAccessoryView: BalanceAccessoryView = {
        return BalanceAccessoryView.instantiate()
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addInputAccessoryViewIntoAmountTextField()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        amountTextField.becomeFirstResponder()
    }
    
    func bindViewModel() {
        let input = SelectAmountViewModel.Input(
            viewWillAppear: rx.viewWillAppear.asDriver(),
            confirmButtonDidTap: confirmButton.rx.tap.asDriver(),
            amountTextFieldDidInput: amountTextField.rx.text.orEmpty.asDriver()
        )
        
        let output = viewModel.build(input: input)
        
        output
            .showSendConfirmationViewController
            .drive(onNext: { [weak self] tansactionContext in
                self?.pushSendConfirmationViewController(with: tansactionContext)
            })
            .disposed(by: disposeBag)
        
        output
            .fiatBalance
            .drive(onNext: { [weak self] balance in
                self?.balanceAccessoryView.apply(input: .balance(balance))
            })
            .disposed(by: disposeBag)
        
        output
            .fiatAmount
            .drive(amountTextField.rx.text)
            .disposed(by: disposeBag)
        
        output
            .etherAmount
            .drive(etherAmountLabel.rx.text)
            .disposed(by: disposeBag)
        
        output
            .txFee
            .drive(onNext: { [weak self] txFee in
                self?.balanceAccessoryView.apply(input: .txFee(txFee))
            })
            .disposed(by: disposeBag)
        
        output
            .error
            .drive(rx.showError)
            .disposed(by: disposeBag)
    }
    
    private func pushSendConfirmationViewController(with transactionContext: TransactionContext) {
        let sendConfirmationViewController = SendConfirmationViewController.make(transactionContext)
        navigationController?.pushViewController(sendConfirmationViewController, animated: true)
    }
    
    private func addInputAccessoryViewIntoAmountTextField() {
        amountTextField.inputAccessoryView = balanceAccessoryView
    }
}
