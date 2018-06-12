//
//  LatestTransactionListViewController.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/04/14.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class LatestTransactionListViewController: UITableViewController {
    
    var viewModel: LatestTransactionListViewModel!
    
    @IBOutlet private weak var emptyView: UIView!
    
    private let disposeBag = DisposeBag()
    private let refresher = UIRefreshControl()
    
    private var emptyViewManager: EmptyViewManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresher.tintColor = UIColor.white
        tableView.addSubview(refresher)
        emptyViewManager = EmptyViewManager(emptyView: emptyView, container: tableView)
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = LatestTransactionListViewModel.Input(
            viewWillAppear: rx.viewWillAppear.asDriver(),
            refreshControlDidRefresh: refresher.rx.controlEvent(.valueChanged).asDriver()
        )
        
        let output = viewModel.build(input: input)
        
        output
            .latestTransactionHistories
            .drive(tableView.rx.items(cellType: LatestTransactionListViewCell.self))
            .disposed(by: disposeBag)
        
        output
            .latestTransactionHistories
            .drive(onNext: { [weak self] transactions in
                if transactions.isEmpty {
                    self?.emptyViewManager.showEmptyView()
                } else {
                    self?.emptyViewManager.removeEmptyView()
                }
            })
            .disposed(by: disposeBag)
        
        output
            .error
            .drive(rx.showError)
            .disposed(by: disposeBag)
        
        output
            .isFetching
            .drive(refresher.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}
