//
//  TransactionHistoryViewController.swift
//  Wei
//
//  Created by omatty198 on 2018/04/12.
//  Copyright © 2018年 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TransactionHistoryViewController: UITableViewController {
    
    var viewModel: TransactionHistoryViewModel!
    
    private let disposeBag = DisposeBag()
    private let refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addSubview(refresher)
        bindViewModel()
    }
    
    func bindViewModel() {
        let input = TransactionHistoryViewModel.Input(
            viewWillAppear: rx.viewWillAppear.asDriver(),
            refreshControlDidRefresh: refresher.rx.controlEvent(.valueChanged).asDriver()
        )
        
        let output = viewModel.build(input: input)
        
        output
            .transactionHistories
            .drive(tableView.rx.items(cellType: TransactionHistoryViewCell.self))
            .disposed(by: disposeBag)
        
        output
            .isExecuting
            .drive(refresher.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        output
            .error
            .drive(rx.showError)
            .disposed(by: disposeBag)
    }
}

