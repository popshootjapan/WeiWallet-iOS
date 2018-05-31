//
//  HomeViewController.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/01.
//  Copyright © 2018 yz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel!
    
    @IBOutlet private weak var myWalletContainerView: UIView!
    @IBOutlet private weak var receiveButton: UIButton!
    @IBOutlet private weak var settingButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        embedMyWalletViewController()
    }
}

private extension HomeViewController {
    func bindViewModel() {
        let input = HomeViewModel.Input(
            settingButtonDidTap: settingButton.rx.tap.asDriver(),
            receiveButtonDidTap: receiveButton.rx.tap.asDriver()
        )
        
        let output = viewModel.build(input: input)
        
        output
            .presentReceiveViewController
            .drive(onNext: { [weak self] in
                self?.presentReceiveViewController()
            })
            .disposed(by: disposeBag)
        
        output
            .pushSettingViewController
            .drive(onNext: { [weak self] in
                self?.pushSettingViewController()
            })
            .disposed(by: disposeBag)
    }
    
    func embedMyWalletViewController() {
        let viewController = MyWalletViewController.make()
        embed(viewController, to: myWalletContainerView)
    }
    
    func presentReceiveViewController() {
        let viewController = ReceiveViewController.make()
        present(viewController, animated: true)
    }
    
    func pushSettingViewController() {
        let viewController = SettingViewController.make()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension HomeViewController: ControllableNavigationBar {
    func setNavigationBarHiddenOnDisplay() -> Bool {
        return true
    }
}
