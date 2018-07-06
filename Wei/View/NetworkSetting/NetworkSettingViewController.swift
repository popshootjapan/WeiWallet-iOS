//
//  NetworkSettingViewController.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/07/06.
//  Copyright © 2018 yz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class NetworkSettingViewController: UITableViewController {
    
    var viewModel: NetworkSettingViewModel!
    
    private let selectedNetwork = PublishSubject<Network>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let output = viewModel.build(input: .init(
            selectedNetwork: selectedNetwork.asDriver(onErrorDriveWith: .empty())
        ))
        
        output
            .networks
            .drive(tableView.rx.items(cellType: NetworkSettingViewCell.self))
            .disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
