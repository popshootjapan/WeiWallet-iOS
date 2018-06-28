//
//  CurrencySettingViewController.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/06/28.
//  Copyright © 2018 yz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CurrencySettingViewController: UITableViewController {
    
    var viewModel: CurrencySettingViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let output = viewModel.build(input: .init(
            selectedIndexPath: tableView.rx.itemSelected.asDriver()
        ))
        
        output
            .currencies
            .drive(tableView.rx.items(cellType: CurrencySettingViewCell.self))
            .disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
