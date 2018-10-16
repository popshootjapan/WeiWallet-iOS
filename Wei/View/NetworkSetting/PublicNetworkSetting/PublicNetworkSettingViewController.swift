//
//  PublicNetworkSettingViewController.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/07/06.
//  Copyright © 2018 yz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class PublicNetworkSettingViewController: UITableViewController {
    
    var viewModel: PublicNetworkSettingViewModel!
    
    private let selectedNetwork = PublishSubject<Network>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let selectedIndexPath = tableView.rx.itemSelected.asDriver().flatMap { [weak self] indexPath -> Driver<IndexPath> in
            let selectedIndexPath = PublishSubject<IndexPath>()
            
            let alertController = UIAlertController(
                title: R.string.localizable.alertSwitchNetwork(),
                message: nil, preferredStyle: .alert
            )
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                selectedIndexPath.onNext(indexPath)
            })
            
            alertController.addAction(UIAlertAction(title: R.string.localizable.commonCancel(), style: .cancel))
            self?.present(alertController, animated: true)
            
            return selectedIndexPath.asDriver(onErrorDriveWith: .empty())
        }
        
        let output = viewModel.build(input: .init(
            selectedIndexPath: selectedIndexPath
        ))
        
        output
            .networks
            .drive(tableView.rx.items(cellType: PublicNetworkSettingViewCell.self))
            .disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
