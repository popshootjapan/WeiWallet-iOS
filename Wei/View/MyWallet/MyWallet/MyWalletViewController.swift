//
//  MyWalletViewController.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/01.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MyWalletViewController: UIViewController {
    
    var viewModel: MyWalletViewModel!
    
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var historyButton: UIButton!
    @IBOutlet private weak var etherBalanceTitleLabel: UILabel!
    @IBOutlet private weak var etherBalanceLabel: UILabel!
    @IBOutlet private weak var fiatBalanceTitleLabel: UILabel!
    @IBOutlet private weak var fiatBalanceLabel: UILabel!
    @IBOutlet private weak var transactionHistoryTitleLabel: UILabel!
    @IBOutlet private weak var transactionListContainer: UIView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        embedLatestTransactionListViewController()
    }
    
    private func bindViewModel() {
        let input = MyWalletViewModel.Input(
            viewWillAppear: rx.viewWillAppear.asDriver(),
            sendButtonDidTap: sendButton.rx.tap.asDriver(),
            historyButtonDidTap: historyButton.rx.tap.asDriver()
        )

        let output = viewModel.build(input: input)

        Driver
            .combineLatest(output.fiatBalance, output.currency)
            .drive(onNext: { [weak self] balance, currency in
                self?.fiatBalanceLabel.text = Formatter.priceString(from: balance.value as NSDecimalNumber, currency: currency)
            })
            .disposed(by: disposeBag)
        
        output
            .etherBalance
            .drive(onNext: { [weak self] balance in
                self?.etherBalanceLabel.text = balance.ether.string
            })
            .disposed(by: disposeBag)

        output
            .presentSendViewController
            .drive(onNext: { [weak self] _ in
                self?.presentSendViewController()
            })
            .disposed(by: disposeBag)

        output
            .pushTransactionHistoryViewController
            .drive(onNext: { [weak self] _ in
                self?.pushTransactionHistoryViewController()
            })
            .disposed(by: disposeBag)

        output
            .presentSuggestBackupViewController
            .drive(onNext: { [weak self] _ in
                let viewController = SuggestBackupViewController.make()
                self?.present(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func embedLatestTransactionListViewController() {
        let viewController = LatestTransactionListViewController.make()
        embed(viewController, to: transactionListContainer)
    }

    private func presentSendViewController() {
        let viewController = SendBaseViewController.make()
        present(viewController, animated: true)
    }
    
    private func pushTransactionHistoryViewController() {
        let viewController = TransactionHistoryViewController.make()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
