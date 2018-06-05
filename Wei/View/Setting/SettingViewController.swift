//
//  SettingViewController.swift
//  Wei
//
//  Created by omatty198 on 2018/04/12.
//  Copyright © 2018年 yz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingViewController: UITableViewController {

    var viewModel: SettingViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // NOTE: Deselect a selected row when view will appear
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func bindViewModel() {
        let input = SettingViewModel.Input(
            itemSelected: tableView.rx.itemSelected.asDriver()
        )
        
        let output = viewModel.build(input: input)
        
        output
            .presentSomeViewController
            .drive(onNext: { [weak self] indexPath in
                switch SettingSection(rawValue: indexPath.section)! {
                case .security:
                    let viewController = BackupViewController.make()
                    self?.navigationController?.pushViewController(viewController, animated: true)
                
                case .transactionSetting:
                    let viewController = AdjustGasPriceViewController.make()
                    self?.navigationController?.pushViewController(viewController, animated: true)
                    
                case .info:
                    self?.showWebView(for: SettingSection.InfoCellType(rawValue: indexPath.row)!)
                }
            })
            .disposed(by: disposeBag)
    }
    
    enum SettingSection: Int {
        case security
        case transactionSetting
        case info
        
        enum InfoCellType: Int {
            case terms
            case policy
        }
    }
    
    private func showWebView(for cellType: SettingSection.InfoCellType) {
        switch cellType {
        case .terms:
            UIApplication.shared.open(URL.wei.terms)
        case .policy:
            UIApplication.shared.open(URL.wei.policy)
        }
    }
}

extension SettingViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
